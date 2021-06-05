

import UIKit
import SwiftyJSON
import ObjectMapper
import Alamofire

class BaseModel:NSObject, Mappable {
    var data:JSON?

    override init() {
        super.init()
    }
    
    required init?(map: Map) {

    }

     // Mappable
    func mapping(map: Map) {
        //
    }
    
    func initWithData(data:Data) -> BaseModel{
        return BaseModel()
    }
    
    func getDataObject() -> Data  {
        return Data();
    }
    
    
    func getJsonObject(method: HTTPMethod) -> Any {
        return getDataObject()
    }
     
}
