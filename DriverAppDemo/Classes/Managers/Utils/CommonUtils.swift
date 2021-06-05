
import Foundation;
import UIKit;
import CoreLocation

class CommonUtils {
   
    static func OSVersion() -> Float {
        return Float(UIDevice.current.systemVersion)!;
    }
    
    static func formatTime(seconds totalSeconds: Int64) -> String{
        let (hours,minutes,_) = CommonUtils.secondsToHoursMinutesSeconds(seconds: totalSeconds)
        let formatedHours = hours == 0 ? "" : ("\(hours)h: ");
        return "\(formatedHours)\(minutes)m";
    }
    
    static func secondsToHoursMinutesSeconds (seconds : Int64) -> (Int64, Int64, Int64) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func dipslayTimeEvent(_ from: Date, _ to: Date) -> String {
        let startStr = DateFormatter.displayTime.string(from: from)
        let endStr = DateFormatter.displayTime.string(from: to)
        
        return "\(startStr) - \(endStr)"
    }
    
    static func imageWithSize(image: UIImage?, size: CGSize) -> UIImage {
        if UIScreen.main.responds(to: NSSelectorFromString("scale")) {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            
        } else {
            UIGraphicsBeginImageContext(size)
        }
        
        image?.draw(in: CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    
    static func getTwoFirstLetter(string:String) -> String {
       var str = ""
       let arr = string.trim(characters: CharacterSet.whitespacesAndNewlines).components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        if arr.count == 1 {
            str = arr[0];
            str = str.substring(to: MIN(2, str.length)).uppercased()
            return str
        }
        
        for item in arr {
            if !isEmpty(item){
                str = str.appending(item.substring(to: 1))
            }
        }
        
        if str.length >= 2 {
            return str.uppercased()
        }
        
        return str
    }
    
    static func getPathDirections(_ origin:CLLocationCoordinate2D,
                              _ destination:CLLocationCoordinate2D,
                              _ waypoints:Array<CLLocationCoordinate2D>) ->String {
        let origin = "\(origin.latitude),\(origin.longitude)"
        let destination = "\(destination.latitude),\(destination.longitude)"
        var path = "/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(Network.googleAPIKey)"

        if waypoints.count > 0 {
            path += "&waypoints=optimize:true"
            for waypoint in waypoints {
                let stringWaypoint = "\(waypoint.latitude),\(waypoint.longitude)"
                path += "|" + stringWaypoint
            }
        }
        path = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        return path
    }
    
    static func convertKilometer(miles:Double) -> Double {
        let km = miles * 1.609344
        return km.rounded(toPlaces: 1)
    }
}
