
import UIKit
import SwiftyJSON
import PhoneNumberKit
import ObjectMapper

enum OrderStatus:String {
    case new = "new"
    case inprogress = "inprogress"
    case completed = "completed"
    case failed = "failed"
    case going = "going"
    
    var name:String{
        switch self {
        case .new:
            return "New"
        case .completed:
            return "Completed"
        case .failed:
            return "Failed"
        case .inprogress:
            return "In-Progress"
        case .going:
            return "Ongoing job"
        }
    }
}

class OrderModel:BaseModel {
    
     var lat:Double = 0
     var long:Double = 0
     var order:Int = 0
     var statusCode:String?
     var reason:String?
     var eta:String?
     var _id:String?
     var id:Int = 1
     var name:String?
     var phone:String?
     var address1:String?
     var address2:String?
     var city:String?
     var state:String?
     var zip:String?
     var shift_id:String?
     var createdAt:String?
     var updatedAt:String?
     var arrivalTime:String?
     var finishTime:String?
     var completedAt:String?
     var waitTime:Int = 0
     var deliverBy:String?
     var late = false
     var notes:String?
     var items:String?
     var paymentAmount:Double = 0
     var package:String?
     var payment:String?
     var driverNotes:String?
     var signature:String?
     var signature_base_64:String?
     var email:String?
     var distance:Double = 0
     var local_id:String?


    
    var marker:Marker{
        get{
            var image:UIImage = #imageLiteral(resourceName: "ic_marker")
            switch status {
            case .completed:
                image = #imageLiteral(resourceName: "ic_marker-completed")
            case .failed:
                image = #imageLiteral(resourceName: "ic_maker_faile")
            default:
                image = #imageLiteral(resourceName: "ic_marker_stop")
            }
            
            return Marker(marker: image, lat: lat, lng: long)
        }
    }
    
    var displayPhoneNumber:String?{
        get{
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumber = try phoneNumberKit.parse(phone ?? "")
                return phoneNumberKit.format(phoneNumber, toType: .international) // (02) 3661 8300
            }
            catch {
                
                return format(phoneNumber: E(phone), shouldRemoveLastDigit: false)
            }
        }
    }
    
    var isValidPhoneNumber:Bool {
        get{

            let phoneNumberKit = PhoneNumberKit()
            return phoneNumberKit.isValidPhoneNumber(phone ?? "")
            
        }
    }
    
    var distanceDisplay:String{
        get{
            return "\(CommonUtils.convertKilometer(miles: distance)) km"
        }
    }
    
    
    var status:OrderStatus {
        get{
            return OrderStatus(rawValue: E(statusCode)) ?? .new
        }
    }
    
    var colorStatus:UIColor {
        get{
            switch status {
            case .completed:
                return AppColor.completedStatus
            case .failed:
                return AppColor.failedStatus

            default:
                return AppColor.goingNext
            }
        }
    }
    
    var canGoingNext:Bool{
        get{
            return status == .new || status == .inprogress || status == .going
        }
    }
    
    var packageDisplay:String {
        get{
            if package == "person" {
                return "Received by Person"
            }else {
                return "Safe Dropped"
            }
        }
    }
    
    var paymentDisplay:String?{
        get{
            if payment == "cash" {
                return "Cash on Delivery"
                
            }else if(payment == "e-transfer"){
                return "E-Transfer"
            }
            
            return nil
        }
    }

    
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        order = json["order"].int ?? 0
        statusCode = json["status"].string
        reason = json["reason"].string
        eta = json["eta"].string
        _id = json["_id"].string
        id = json["id"].int ?? 1
        name = json["name"].string
        phone = json["phone"].string
        address1 = json["address1"].string
        address2 = json["address2"].string
        city = json["city"].string
        state = json["state"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        arrivalTime = json["arrivalTime"].string
        finishTime = json["finishTime"].string
        zip = json["zip"].string
        lat = json["lat"].doubleValue
        long = json["lng"].doubleValue
        if let _lat = json["lat"].string {
            lat = Double(_lat) ?? 0
        }
        if let _lng = json["lng"].string {
            long = Double(_lng) ?? 0
        }
        lat = json["lat"].doubleValue
        long = json["lng"].doubleValue
        waitTime = json["waitTime"].int ?? 0
        deliverBy = json["deliverBy"].string
        late = json["late"].bool ?? false
        notes = json["notes"].string
        items = json["items"].string
        package = json["package"].string
        paymentAmount = json["paymentAmount"].double ?? 0
        completedAt = json["completedAt"].string
        payment = json["payment"].string
        driverNotes = json["driverNotes"].string
        signature = json["signature"].string
        email = json["email"].string
        distance = json["distance"].double ?? 0
        shift_id = ""
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        order <- map["order"]
        statusCode <- map["status"]
        reason <- map["reason"]
        eta <- map["eta"]
        _id <- map["_id"]
        name <- map["name"]
        phone <- map["phone"]
        address1 <- map["address"]
        address2 <- map["address2"]
        city <- map["city"]
        state <- map["state"]
        createdAt <- map["createdAt"]
        lat <- map["lat"]
        long <- map["lng"]
        waitTime <- map["waitTime"]
        deliverBy <- map["deliverBy"]
        late <- map["late"]
        notes <- map["notes"]
        items <- map["items"]
        package <- map["package"]
        paymentAmount <- map["paymentAmount"]
        completedAt <- map["completedAt"]
        payment <- map["payment"]
        driverNotes <- map["driverNotes"]
        signature <- map["signature"]
        email <- map["email"]
        distance <- map["distance"]
        id <- map["id"]
    }
    
    func toJSONString() -> [String:Any] {
        let json  = ["order": order,
                    "statusCode":E(statusCode),
                    "reason":E(reason),
                    "eta":E(eta),
                    "_id":E(_id),
                    "name":E(name),
                    "phone":E(phone),
                    "address1":E(address1),
                    "address2":E(address2),
                    "city":E(city),
                    "state":E(state),
                    "lat":lat,
                    "lng":long,
                    "shift":shift_id ?? "",
                    "createdAt":E(createdAt),
                    "arrivalTime":E(arrivalTime),
                    "finishTime":E(finishTime),
                    "zip":E(zip),
                    "waitTime":waitTime ,
                    "deliverBy":deliverBy ?? "",
                    "late":late,
                    "notes":notes ?? "",
                    "distance":distance,
                    "updatedAt":E(updatedAt)] as [String : Any]

        return json
    }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")

        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }

        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }

        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)

        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }

        return number
    }
    
}
