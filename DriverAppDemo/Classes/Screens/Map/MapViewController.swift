//
//  ViewController.swift
//  TLDemo
//
//  Created by Apple on 3/1/21.
//

import UIKit
import GoogleMaps
import CoreLocation

struct Marker {
    var marker: UIImage
    var size: Int = 35
    var lat: Double
    var lng: Double
    var zIndex: Int32 = 0
    var currentLocation: Bool = false
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblLocation: UILabel?
    @IBOutlet weak var swOnOffLocation: UISwitch?

    var currentLocationMarker: GMSMarker?
    var mapBearing: Double = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.requestLocation()
        LocationManager.shared.delegate = self
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         if CLLocationManager.locationServicesEnabled() {
             addCurrentLocationMarker()
         }
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupUI()  {
        swOnOffLocation?.isOn = Cache.shared.allowTrackingLocation
        updateHeaaderView()
        setupMap()
    }
    
    func updateHeaaderView() {
        lblLocation?.text = "\(LocationManager.shared.currentLocation?.coordinate.latitude.rounded(toPlaces:6) ?? 0), \(LocationManager.shared.currentLocation?.coordinate.longitude.rounded(toPlaces:6) ?? 0)"
        if Cache.shared.allowTrackingLocation {
            swOnOffLocation?.thumbTintColor = AppColor.primary
            swOnOffLocation?.onTintColor = .white
        }else{
            swOnOffLocation?.thumbTintColor = .white
            swOnOffLocation?.onTintColor = .white
        }
    }
    
    func setupMap() {
        mapView.isMyLocationEnabled = false
        if let locationFocus = LocationManager.shared.currentLocation?.coordinate {
            focusToLocation(location: locationFocus)
        }
    }
    
    func focusToLocation(location:CLLocationCoordinate2D)  {
        let position = GMSCameraPosition(latitude: location.latitude, longitude: location.longitude, zoom: 15)
        mapView.animate(to: position)
    }
    
    func addCurrentLocationMarker() {
        currentLocationMarker?.map = nil
        currentLocationMarker = nil
        if let location = LocationManager.shared.currentLocation {
            currentLocationMarker = GMSMarker(position: location.coordinate)
            currentLocationMarker?.icon = UIImage(named: "ic_currentLocation_driver")
            currentLocationMarker?.map = mapView
            currentLocationMarker?.rotation = location.course
        }
    }

    func zoomToCoordinates(_ coordinates: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude,
                                              longitude: coordinates.longitude, zoom: 15)
        mapView.camera = camera
    }
    
    //MARK: - ACTIONS
    @IBAction func onChangeSwitchStatus(sender:UISwitch){
        Cache.shared.allowTrackingLocation = sender.isOn
        updateHeaaderView()
    }
}


//MARK: - LocationManagerDelegate
extension MapViewController:LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation?) {
        //Call api to the backend
        self.updateCurrentLocationToServer(location)
        
        // Update UI
        self.updateHeaaderView()
        if let currentLocation = location?.coordinate {
            currentLocationMarker?.position = currentLocation
            currentLocationMarker?.rotation = location?.course ?? 0
            //self.zoomToCoordinates(currentLocation)
            self.focusToLocation(location: currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Do something
    }
}

//MARK: - API
extension MapViewController {
    func updateCurrentLocationToServer(_ location:CLLocation?) {
        if !Cache.shared.allowTrackingLocation {
            return
        }
        if let lastUpdateLocation = Cache.shared.lastUpdateLocation {
            let time = Date().timeIntervalSince1970 - lastUpdateLocation.time
            if(time < 20){
                return
            }
        }
        
        guard let _currentLocation = location?.coordinate else {return}
        Cache.shared.lastUpdateLocation = (lat:_currentLocation.latitude,lng:_currentLocation.longitude,time:Date().timeIntervalSince1970)
       /* RealtimeDBAPI.shared.trackingLocation(location: _currentLocation) { (result) in
            //
        } */
    }
}



