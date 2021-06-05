
import UIKit
import Alamofire

class APIError: NSObject {
    var code:BaseAPI.StatusCode?
    var message:String?
    
    override init() {
        super.init()
    }
    
   required init(dataResponse: AFDataResponse<Any>) {
        super.init()
        code = statusCode(in: dataResponse)
        message = errorMessage(for: dataResponse);
    }
}

fileprivate extension APIError {
    func statusCode(in dataResponse: AFDataResponse<Any>) -> BaseAPI.StatusCode? {
        guard let statusCode = dataResponse.response?.statusCode else {
            return nil
        }
        
        return BaseAPI.StatusCode(rawValue: statusCode)
    }
    
    func errorMessage(for dataResponse: AFDataResponse<Any>) -> String? {
        guard let object = dataResponse.value as? ResponseDictionary else {
            return nil
        }
        
        var message = object["ErrorMessage"] as? String
        
        if message == nil {
            message = object["message"] as? String
        }
        
        return message
    }
}
