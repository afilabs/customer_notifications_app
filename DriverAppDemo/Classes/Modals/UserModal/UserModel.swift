
import UIKit
import SwiftyJSON
import ObjectMapper

class CompanyModel: BaseModel {
    var phone:String?
    var disabled:Bool?
    var _id:String?
    var name:String?
    
    required init(json: JSON?) {
        super.init()
        _id = json?["_id"].string
        phone = json?["phone"].string
        disabled = json?["disabled"].bool
        name = json?["name"].string
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    
    override func mapping(map: Map) {
        //
    }
    func toJSONString() -> [String:Any] {
        let json  = ["_id": E(_id),
                     "phone":E(phone),
                     "name":E(name),
                     "disabled":disabled ?? true] as [String : Any]
        
        return json
    }

}

class UserModel: BaseModel {
    
    var _id:String?
    var token:String?
    var resetPasswordToken:String?
    var deleted:Bool?
    var disabled:Bool?
    var routeId:String?
    var name:String?
    var phone:String?
    var email:String?
    var role:String?
    var salt:String?
    var password:String?
    var company:CompanyModel?
    var expiryDate:String?
    
    var isRegisteredDevice:Bool {
        return company?._id != nil
    }
    

    
    required init(json: JSON?) {
        super.init()
        _id = json?["_id"].string
        token = json?["token"].string
        resetPasswordToken = json?["resetPasswordToken"].string
        deleted = json?["deleted"].bool
        disabled = json?["disabled"].bool
        routeId = json?["routeId"].string
        name = json?["name"].string
        email = json?["email"].string
        role = json?["role"].string
        salt = json?["salt"].string
        password = json?["password"].string
        company = CompanyModel(json: json?["company"])
        expiryDate = json?["expiryDate"].string
        phone = json?["phone"].string

    }
    

    override func mapping(map: Map) {
        //
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    
    
    func toJSONString() -> [String:Any] {
        let json  = ["_id": E(_id),
                     "token":E(token),
                     "resetPasswordToken":E(resetPasswordToken),
                     "deleted":deleted ?? true,
                     "disabled":disabled ?? true,
                     "routeId":E(routeId),
                     "name":E(name),
                     "email":E(email),
                     "role":E(role),
                     "phone":E(phone),
                     "password":E(password),
                     "expiryDate":E(expiryDate),
                     "company":company?.toJSONString() ?? [:]] as [String : Any]
        
        return json
    }
    
}
