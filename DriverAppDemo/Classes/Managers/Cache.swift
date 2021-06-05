

import UIKit

class Cache: NSObject {
    static let shared = Cache()
    let userDefaults = UserDefaults.standard
    
    var allowTrackingLocation:Bool{
        set{
            userDefaults.set(newValue, forKey: USER_DEFAULT_KEY.HF_ALLOW_TRACKING_LOCATION)
        }
        get{
            return userDefaults.object(forKey: USER_DEFAULT_KEY.HF_ALLOW_TRACKING_LOCATION) as? Bool ?? true
        }
    }
    
    var lastUpdateLocation:(lat:Double,lng:Double,time:Double)?{
        set{
            let location:[String:Any] = ["lat":newValue?.lat ?? 0,"lng":newValue?.lng ?? 0,"time":newValue?.time ?? 0]
            userDefaults.set(location, forKey: USER_DEFAULT_KEY.LAST_UPDATE_LOCATION)
        }
        get{
            if let location = userDefaults.object(forKey: USER_DEFAULT_KEY.LAST_UPDATE_LOCATION) as? [String:Any],
                let lat = location["lat"] as? Double,
                let lng = location["lng"] as? Double,
                let time = location["time"] as? Double {
                return (lat:lat, lng:lng, time: time)
            }
            return nil
        }
    }
}
