
import UIKit

class AttachFileModel: BaseModel {
  
    var mimeType:String? = "application/octet-stream"
    let boundary:String = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
    let serverS3 = "https://images1-focus-opensocial.googleusercontent.com/gadgets/proxy"
  
    var name:String?
    var id:Int = 0
    var contentFile:Data?
    var type:String?
    var url:String?
    var param:String?
    var typeFile:String?
    var url_thumbnail:String?
    
    var urlS3:String{
        get{
            return "\(serverS3)?container=focus&resize_w=60&url=\(E(url))"
        }
    }

//    required convenience init?(map: Map) {
//        self.init()
//    }
//  
//    override func mapping(map: Map) {
//        id <- map["id"]
//        name <- map["name"]
//        url <- map["url"]
//        typeFile <- map["type"]
//        url_thumbnail <- map["url_thumbnail"]
//    }
//  
//  
//    override func getJsonObject(method: ParamsMethod) -> Any {
//        let dic:ResponseDictionary = [:]
//        if (method == .POST) { // upload file
//            
//        //let contentType = "multipart/form-data; boundary=" + boundary
//      
//        let fileParamConstant = "file_sig_req"
//        let boundaryStart = "--\(boundary)\r\n"
//        let boundaryEnd = "--\(boundary)--\r\n"
//        let contentDispositionString = "Content-Disposition: form-data; name=\"\(fileParamConstant)\"; filename=\"\(E(name))\"\r\n"
//
//        let contentTypeString = "Content-Type: \(E(mimeType))\r\n\r\n"
//      
//        let requestBodyData : NSMutableData = NSMutableData()
//      
//       //value
//        requestBodyData.append(boundaryStart.data(using: String.Encoding.utf8)!)
//        requestBodyData.append(contentDispositionString.data(using: String.Encoding.utf8)!)
//        requestBodyData.append(contentTypeString.data(using: String.Encoding.utf8)!)
//        requestBodyData.append(contentFile!)
//        requestBodyData.append("\r\n".data(using: String.Encoding.utf8)!)
//        requestBodyData.append(boundaryEnd.data(using:  String.Encoding.utf8)!)
//      
//        return requestBodyData;
//
//    }else {
//      //
//    }
//    
//    return dic
//  }
    
    func getDataObject(_ fileParam:String? = nil) -> NSMutableData {
        //let contentType = "multipart/form-data; boundary=" + boundary
        
        let fileParamConstant = (fileParam != nil) ? fileParam! : E(param)
        let boundaryStart = "--\(boundary)\r\n"
        let boundaryEnd = "--\(boundary)--\r\n"
        let contentDispositionString = "Content-Disposition: form-data; name=\"\(fileParamConstant)\"; filename=\"\(E(name))\"\r\n"
        
        let contentTypeString = "Content-Type: \(E(mimeType))\r\n\r\n"
        
        let requestBodyData : NSMutableData = NSMutableData()
        
        //value
        requestBodyData.append(boundaryStart.data(using: String.Encoding.utf8)!)
        requestBodyData.append(contentDispositionString.data(using: String.Encoding.utf8)!)
        requestBodyData.append(contentTypeString.data(using: String.Encoding.utf8)!)
        requestBodyData.append(contentFile!)
        requestBodyData.append("\r\n".data(using: String.Encoding.utf8)!)
        requestBodyData.append(boundaryEnd.data(using:  String.Encoding.utf8)!)
        
        return requestBodyData;
  }
}
