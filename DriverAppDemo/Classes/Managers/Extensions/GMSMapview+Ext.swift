

import Foundation


import GoogleMaps

enum MarkerType {
    case Normal
    case From
    case To
    case Pickup
    case Delivery
    case Port
}

extension GMSMapView {
    
    func showMarker(location:CLLocationCoordinate2D,
                              icon:UIImage? = nil,
                              text:String? = nil,
                              name:String? = nil,
                              snippet:String? = nil) {
          let marker = GMSMarker(position: location)
          marker.title = name
          marker.snippet = snippet
          marker.map = self
          marker.zIndex = 1
          
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = icon
        imageView.contentMode = .scaleAspectFit
        
        marker.iconView = imageView
    }
    
    
    func showMarker(type:MarkerType,
                            location:CLLocationCoordinate2D,
                            iconName:String? = nil,
                            text:String? = nil,
                            name:String? = nil,
                            snippet:String? = nil) {
        let marker = GMSMarker(position: location)
        marker.title = name
        marker.snippet = snippet
        marker.map = self
        marker.zIndex = 1
        
        switch type {
        case .From:
            let labelOrder = labelMarkerWithText("From".localized.uppercased(), .From)
            marker.iconView = labelOrder
            
        case .To:
            let labelOrder = labelMarkerWithText("To".localized.uppercased(),.To)
            marker.iconView = labelOrder
        case .Pickup:
            let labelOrder = labelMarkerWithText("Pick Up".localized.uppercased(),.Pickup)
            marker.iconView = labelOrder
        case .Delivery:
            let labelOrder = labelMarkerWithText("Delivery".localized.uppercased(),.Delivery)
            marker.iconView = labelOrder
            
        case .Port:
            let portMarker = self.portMarker(E(iconName))
            marker.iconView = portMarker
            
        case .Normal:
            let portMarker = labelMarkerWithText(E(text),.Normal)
            marker.iconView = portMarker
        }
    }
    
    /*
    func drawPath(fromLocation from: CLLocationCoordinate2D,
                  toLocation to: CLLocationCoordinate2D,
                  wayPoints:Array<CLLocationCoordinate2D>,
                  complation:@escaping (Bool,[DirectionRoute]?) -> Void) {
        SERVICES().API.getDirection(origin: from,
                           destination: to,
                           waypoints: wayPoints) {[weak self] (result) in
                            switch result{
                            case .object(let obj):
                                for route in obj.routes {
                                    self?.drawPath(directionRoute: route)
                                }
                                complation(true,obj.routes)
                            case .error(let error):
                                //self?.showAlertView(error.getMessage())
                                complation(false,nil)
                                break
                            }
        }
    }
    
    func drawPath(directionRoute:DirectionRoute)  {
        let path = GMSPath(fromEncodedPath: directionRoute.polyline)
        let polyLine = GMSPolyline.init(path: path)
        polyLine.strokeWidth = Constants.ROUTE_WIDTH
        polyLine.strokeColor = AppColor.mainColor
        polyLine.map = self
        let bounds = GMSCoordinateBounds(path: path!)
        self.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
    }
    
    */
    
    // MARK: - Private funtion
    private func labelMarkerWithText(_ text:String,_ type:MarkerType) -> UILabel {
        let labelOrder = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        labelOrder.text = text
        labelOrder.font = UIFont.systemFont(ofSize: 14)
        labelOrder.textAlignment = .center
        labelOrder.textColor = .white
        labelOrder.clipsToBounds = true
        labelOrder.cornerRadius = labelOrder.frame.width / 2

        switch type {
        case .From:
            labelOrder.backgroundColor = AppColor.grayColor
            labelOrder.frame = CGRectMake(0, 0, 60, 30)
            labelOrder.cornerRadius = 5

        case .To:
            labelOrder.backgroundColor = AppColor.mainColor
            labelOrder.frame = CGRectMake(0, 0, 60, 30)
            labelOrder.cornerRadius = 5
            
        case .Pickup:
            labelOrder.backgroundColor = AppColor.grayColor
            labelOrder.frame = CGRectMake(0, 0, 80, 30)
            labelOrder.cornerRadius = 5
            
        case .Delivery:
            labelOrder.backgroundColor = AppColor.mainColor
            labelOrder.frame = CGRectMake(0, 0, 80, 30)
            labelOrder.cornerRadius = 5

        default:
            break
        }
        return labelOrder
    }
    
    private func portMarker(_ iconName:String) -> UIImageView {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        image.image = UIImage(named: iconName)
        image.contentMode = .scaleAspectFit
        return image
    }
    
}

