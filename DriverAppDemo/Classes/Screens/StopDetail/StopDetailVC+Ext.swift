
import Foundation
import UIKit

//MARK:  -API
extension StopDetailVC{
    
    func getStopByid(stop_id:Int) {
        App().showLoading()
        API.getStopById(id: stop_id) { (result) in
            App().dismissLoading()
            switch result{
            case .object(let stop):
                let newStop = stop
                newStop.id = stop_id
                if newStop.lat == 0 && newStop.long == 0 { // get a default coordinate
                    newStop.lat = (LocationManager.shared.currentLocation?.coordinate.latitude ?? 1) + 0.05 //11.1579558
                    newStop.long = (LocationManager.shared.currentLocation?.coordinate.longitude ?? 1) //106.6876931
                }
                self.stop = newStop

                break
            case .error(let error):
                //self.showAlertView(error.message)
                break
            }
        }
    }
    
    func sendMessageToCustomer(stop_id:Int, message:String)  {
        let params:[String:Any] = ["msg":message,
                                   "address":stop?.address1 ?? "",
                                   "eta":stop?.eta ?? "",
                                   "phone":stop?.phone ?? ""]
        App().showLoading()
        API.sendETAToCustomer(params: params, callback: { (result) in
            App().dismissLoading()
            App().showAlert("Successfully", "You have sent an ETA to the customer.")
        })
    }
    
    func goingNextStop(stop_id:String, note:String? = nil)  {
        //
    }
}


//MARK: - HELPER FUNTIONS
extension StopDetailVC{
    func showMapNavigate(stop:OrderModel)  {
        let alert = UIAlertController(title: "Select an Action",
                                             message: nil,
                                             preferredStyle: .actionSheet)

        let ditectionAction = UIAlertAction(title: "Get Directions from Waze",
                                               style: .default) {[weak self] (action) in
                                                    var place = Place()
                                                    let location = PLocation(lat: stop.lat, lng: stop.long)
                                                    place.geometry = PGeometry(location: location)
                                                    place.formattedAddress = stop.address1
                                                    self?.openWazeNavigation(place: place)
        }
        
        
        let ditectionGoogleMapAction = UIAlertAction(title: "Get Directions from Google",
                                               style: .default) {[weak self] (action) in
                                                
                                                var place = Place()
                                                let location = PLocation(lat: stop.lat, lng: stop.long)
                                                place.geometry = PGeometry(location: location)
                                                place.formattedAddress = stop.address1
                                                
                                                self?.openGoogleMapsNavigation(place: place)

                                   
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                  style: .cancel, handler: nil)

        alert.addAction(ditectionAction)
        alert.addAction(ditectionGoogleMapAction)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }
    
    func openGoogleMapsNavigation(place:Place)  {
        var urlString = "https://itunes.apple.com/us/app/google-maps-gps-navigation/id585027354?mt=8"
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let daddr = place.formattedAddress ?? "\(place.geometry?.location?.lat ?? 0),\(place.geometry?.location?.lng ?? 0)"
            urlString = "comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving"
        }

        guard let url = URL(string: urlString.encodeURLForMap() ?? "")  else {
            NSLog("Can't use comgooglemaps://");
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func openWazeNavigation(place:Place)  {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            let urlStr = "https://waze.com/ul?ll=\(place.geometry?.location?.lat ?? 0),\(place.geometry?.location?.lng ?? 0)&navigate=yes"
           
            guard let url = URL(string: urlStr) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }else {
            
            guard let url = URL(string: "http://itunes.apple.com/us/app/id323229106") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }
    
    
    func sendMessageToCustomerIfNeed()  {
        let alert = UIAlertController(title: "Select what to send customer",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let sendETA = UIAlertAction(title: "Send ETA",
                                                  style: .default) {[unowned self] (action) in
            self.getMessageTemplate(type: "send-eta")

        }
        
        let arrivingSoon = UIAlertAction(title: "Arriving Soon",
                                                style: .default) { (action) in
            self.getMessageTemplate(type: "arriving-soon")
        }
         
        
        let cancel = UIAlertAction(title: "action.cancel".localized,
                                   style: .cancel, handler: nil)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(sendETA)
        alert.addAction(arrivingSoon)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }
    
    func getMessageTemplate(type:String)  {
        /*
        if isEmpty(stop?.phone) && isEmpty(stop?.email) {
            return
        }
        
        APIProviders.getMessageTemplate(stop_id: stop?._id ?? "", type: type).done {[unowned self] (data) in
            let notiTypes = data.result.notificationType
            let mess = data.result.notifyOnGoingMsg
            let title = data.result.title
            let description = data.result.description

            if (notiTypes.contains("sms") && !isEmpty(self.stop?.phone)) ||
                (notiTypes.contains("email") && !isEmpty(self.stop?.email)){
                self.showAlertConfirm(mess: mess,title:title,description:description)
            }

        }.catch {[unowned self] (error) in
            //let oldText = stop?.arrivalTime != nil ? "Your order is on the way and will be there at \(stop?.arrivalTime ?? "")" : "Your order is on the way"
            self.showAlertConfirm(mess: "Send ETA",title:"",description:"")
        }
         */
    }
    
    func showAlertConfirm(mess:String,title:String,description:String)  {
        let alertInput = UIAlertController(title: title,
                                           message: description,
                                           preferredStyle: .alert)
        
        //let oldText = stop?.arrivalTime != nil ? "Your order is on the way and will be there at \(stop?.arrivalTime ?? "")" : "Your order is on the way"
        alertInput.showTextViewInput(placeholder: "",
                                     nameAction: "Send",
                                     oldText: mess) {[unowned self] (success, content) in
                                        guard let stop_id  = self.stop?.id else {return}
                                        self.sendMessageToCustomer(stop_id: stop_id, message: content)
        }
    }
}
