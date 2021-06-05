
import Foundation
import Alamofire;
import ObjectMapper

fileprivate var __identifier: UInt = 0;

enum APIOutput<T, E> {
    case object(T);
    case error(E);
}

enum APIInput {
    case empty;
    case dto(BaseModel); //dto: DataObject
    case json(Any); //dic: Dictionary
    case str(String, in: String?); //str: String
    case data(Data);
    case mutiFile([AttachFileModel])
}

protocol APIDataPresentable {
    var rawData: Data {get set}
}

typealias APIParams = [String: Any];
typealias GenericAPICallback<RESULT, ERROR> = (_ result: APIOutput<RESULT , ERROR>) -> Void;
typealias APICallback<RESULT> = GenericAPICallback<RESULT, APIError>;

class BaseAPI {
    
    static var sharedAPI:BaseAPI?

    enum StatusCode: Int {
        case success = 200
        case invalidInput = 400
        case notAuthorized = 401
        case serverError = 721
        case tokenFail = 603
    }
    
    fileprivate let sessionManager: Alamofire.Session;
    fileprivate let responsedCallbackQueue: DispatchQueue;
    
    static func shared() -> BaseAPI {
        if BaseAPI.sharedAPI == nil {
            let smConfig = URLSessionConfiguration.default
            smConfig.timeoutIntervalForRequest = 30;
            let sessionMgr: Alamofire.Session = Alamofire.Session(configuration: smConfig);
            BaseAPI.sharedAPI = BaseAPI(sessionMgr: sessionMgr);
        }
        return BaseAPI.sharedAPI!;
    }
    
    
    init(sessionMgr:Alamofire.Session) {
        sessionManager = sessionMgr;
        responsedCallbackQueue = DispatchQueue.init(label: "api_responsed_callback_queue");
    }
    
    fileprivate  func getHeaders() -> HTTPHeaders {
        
        let headers:HTTPHeaders = ["Content-Type": "application/json",
                       "Accept": "application/json"]
        
        return headers
    }
    
    
    fileprivate func requestHeader(headers:HTTPHeaders?,
                       url: String? = nil,
                       method: HTTPMethod? = .get,
                       bodyData: Data? = nil,
                       bodyString: String? = nil) -> HTTPHeaders {
        var newHeaders = getHeaders()
        
        if let hds = headers {
            newHeaders = hds
        }
        // setToken
        /*
        if (Cache.shared.getToken().length > 0) {
            newHeaders["Authorization"] = "Bearer \(Cache.shared.getToken())"
        }
        */
        return newHeaders;
    }
    
    func request<RESULT:BaseModel, ERROR: APIError>(method: HTTPMethod,
                serverURL:String  = SERVER_URL.API,
                headers:HTTPHeaders? = nil,
                path: String,
                input: APIInput,
                callback:@escaping GenericAPICallback<RESULT, ERROR>) -> APIRequest{
        
        __identifier += 1;
        
        let identifier = __identifier;
        let url = serverURL.appending(path);
       
        func APILog(_ STATUS: String, _ MSG: String?) {
            print(">>> [API]  [\( String(format: "%04u", identifier) )] [\( method )] [\( path )] \( STATUS )");
            if let msg = MSG { print("\( msg )\n\n"); }
        }
        
        let encoding = APIEncoding(input, method: method);
        
        let headers = requestHeader(headers: headers,
                                    url: url,
                                    method: method,
                                    bodyData: encoding.bodyDataValue,
                                    bodyString: encoding.bodyStringValue)
        
        APILog("REQUEST", encoding.bodyStringValue);
        
        let request: DataRequest;
        
        request = sessionManager.request(url,
                                         method: method,
                                         parameters: [:],
                                         encoding: encoding,
                                         headers: headers);
        
        request.responseJSON(queue: responsedCallbackQueue, options: .allowFragments) { (dataResponse) in
            
            let result: APIOutput<RESULT, ERROR>;
            
            let logResult = dataResponse.data != nil ? String(data: dataResponse.data!, encoding: .utf8) : "<empty>";
            var logStatus : String;
            
            if let statusCode = dataResponse.response?.statusCode {
                logStatus = String(statusCode);
            }else if let anError = dataResponse.error {
                logStatus = "\(anError)";
            }else{
                logStatus = "Unexpected Error!";
            }
            
            APILog("RESPONSE-\(logStatus)", logResult);
            
            switch dataResponse.result {
            case .success(let object):
                result = self.handleResponse(dataResponse: dataResponse, object: object)
                
            case .failure(let error):
                result = self.handleFailure(dataResponse: dataResponse, error: error)
            }
            
            DispatchQueue.main.async {
                callback(result);
            }
        };
        
        return APIRequest(alarmofireDataRequest: request);
    }
}



fileprivate extension BaseAPI{
    func handleResponse<RESULT:BaseModel, ERROR: APIError>(dataResponse: AFDataResponse<Any>, object: Any) -> APIOutput<RESULT, ERROR> {
        
        let status: StatusCode = StatusCode(rawValue: (dataResponse.response?.statusCode)!) ?? .serverError
        switch status {
        case .success:
            
            if let dictionary = object as? [String: Any], let obj = Mapper<RESULT>().map(JSON: dictionary) {
                return .object(obj)
                
            }else if let arrDictionary = object as? [[String: Any]] {
                //let list = Mapper<RESULT>().mapArray(JSONArray: arrDictionary)
                let err = ERROR(dataResponse: dataResponse)

                return .error(err)
            }

            let err = ERROR(dataResponse: dataResponse)
            return .error(err)
            
        default:
            break;
        }
        
        let err = ERROR(dataResponse: dataResponse)
        return .error(err)
    }
    
    
    func handleFailure<RESULT, ERROR: APIError>(dataResponse: AFDataResponse<Any>, error: Error) -> APIOutput<RESULT, ERROR>  {
        let err = ERROR(dataResponse: dataResponse)
        err.message = error.localizedDescription;
        
        return .error(err)
    }
}

//MARK: - Encoding

extension BaseAPI {
    
    struct APIEncoding: ParameterEncoding {
        
        var bodyStringValue: String? = nil
        var bodyDataValue: Data? = nil
        
        init(_ theInput: APIInput, method: HTTPMethod) {
            
            func parseJson(_ rawObject: Any) -> (data: Data, string: String)? {
                
                guard let jsonData = (try? JSONSerialization.data(withJSONObject: rawObject, options: .init(rawValue: 0))) else {
                    print("Couldn't parse [\(rawObject)] to JSON");
                    return nil;
                }
                
                let jsonString = String(data: jsonData, encoding: .utf8)!;
                return (data: jsonData, string: jsonString);
            }
            
            switch theInput {
            case .empty:
                bodyStringValue = nil;
                bodyDataValue = nil;
                
            case .dto(let info):
                let params = info.getJsonObject(method: method)
                if (((params as? ResponseDictionary) != nil) ||
                    ((params as? ResponseArray) != nil))  {
                    
                    let jsonValues = parseJson(params);
                    bodyStringValue = jsonValues?.string;
                    bodyDataValue = jsonValues?.data;
                    
                }else if let prs = params as? Data {
                    bodyStringValue = String.init(data: prs, encoding: .utf8);
                    bodyDataValue = prs;
                }
                
            case .json(let jsonObject):
                let jsonValues = parseJson(jsonObject);
                bodyStringValue = jsonValues?.string;
                bodyDataValue = jsonValues?.data;
                
            case .str(let string, let inString):
                let sideString = inString ?? "";
                bodyStringValue = "\(sideString)\(string)\(sideString)";
                bodyDataValue = bodyStringValue?.data(using: .utf8, allowLossyConversion: true);
                
            case .data(let data):
                bodyStringValue = String.init(data: data, encoding: .utf8);
                bodyDataValue = data;
                
            case .mutiFile(let files):
                let data = getMutiDataFromFile(files: files)
                bodyStringValue = String.init(data: data, encoding: .utf8);
                bodyDataValue = data;
            }
        }
        
        
        func getMutiDataFromFile(files:[AttachFileModel]) -> Data {
            let mutiData:NSMutableData = NSMutableData()
            
            for file in files {
                let data = file.getJsonObject(method: HTTPMethod.post)
                if let data = data as? Data {
                    mutiData.append(data);
                }else {
                    print("Data Invalid.")
                }
            }
            
            return mutiData as Data;
        }
        
        
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var request = try urlRequest.asURLRequest();
            request.httpBody = bodyDataValue;
            return request;
        }
    }
}

//MARK: - API Request

class APIRequest {
    
    private var alarmofireDataRequest: DataRequest? = nil;
    
    required init(alarmofireDataRequest request: DataRequest){
        alarmofireDataRequest = request;
    }
    
    func cancel() {
        if let request = alarmofireDataRequest {
            request.cancel();
        }
    }
    
}

