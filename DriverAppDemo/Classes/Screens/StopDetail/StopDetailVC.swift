
import UIKit
import GoogleMaps
import Alamofire
import ObjectMapper

class StopDetailVC: BaseVC {
    
    enum StopDetailInfoRow:Int {
        case Estimate = 0
        case Actions
    }
    
    @IBOutlet weak var mapView: GMSMapView?
    @IBOutlet weak var tbvContent: UITableView?

    
    private let identifierEstimateCell = "StopDetailEstimateCell"
    private let identifierActionCell = "StopDetailActionCell"
    private var arrIdentifierCells:[String] = []
    
    var stopList:[OrderModel] = []
    var mapDirectionResponse:MapDirectionResponse?
    
    
    let section: Alamofire.Session = {
        let smConfig = URLSessionConfiguration.af.default
        smConfig.timeoutIntervalForRequest = 30;
        return Alamofire.Session(configuration: smConfig)
    }()
    
    
    var stop:OrderModel?


    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.delegate = self
        initVar()
        updateUI()
        setupTableView()
        setupMapView()
        getDataFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateStopSuccess(notification:)),
                                               name: .updateStopSuccessfully,
                                            object: nil)
        
    }
    
    override func setupHeaaderView() {
        headerView?.setHeaderView(type: .titleOnly,
                                  title: stop?.name ?? "Stop Detail",
                                  disableRightButton: true)
        headerView?.delegate = self
    }
    
    func getDataFromServer()  {
        /*
        if let id = stop?.id {
            getStopByid(stop_id: id)
        }
        */
        
        let url = "https://customer-notifications-sample.herokuapp.com/stops/\(stop?.id ?? 1)"
        App().showLoading()
        section.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {[weak self] (response) in
            App().dismissLoading()
            switch response.result{
            case .success(let obj):
                print("==>ResponseJSON:\(obj)")
                //Mapping JSON to OrderModel
                if let dictionary = obj as? [String: Any],
                   let order = Mapper<OrderModel>().map(JSON: dictionary) {
                    self?.stop = order
                    self?.tbvContent?.reloadData()
                    self?.updateUI()
                    
                }else{
                    // Invalid data.
                    print("==>Invalid data.")
                }

                break
            case .failure(let error):
                print("==>Error:\(error.localizedDescription)")
                //Show Alert if need
                self?.showAlertView(error.localizedDescription)
                break
            }
        }
    }
    
    
    // MARK: - SETUP
    func setupTableView()  {
        tbvContent?.delegate = self
        tbvContent?.dataSource = self
    }
    
    func setupMapView() {
        guard let lat = stop?.lat,let lng = stop?.long else {
            return
        }
        mapView?.clear()
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapView?.showMarker(location: location, icon: #imageLiteral(resourceName: "ic_marker"))
        mapView?.isMyLocationEnabled = true
        
        if let firstLocation = LocationManager.shared.currentLocation?.coordinate {
            drawPath(fromLocation: firstLocation,
                     toLocation: location,
                     wayPoints: [])
        }

        /*
        let firstLocation = location
        var bounds = GMSCoordinateBounds(coordinate: firstLocation, coordinate: firstLocation)
            
        if let currentLocation = LocationManager.shared.currentLocation?.coordinate {
            bounds = bounds.includingCoordinate(currentLocation)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(20))
        mapView?.animate(with: update)
        */
    }
    
    func drawPathMap()  {
        guard let lat = stop?.lat,
              let lng = stop?.long,
              let currentLocation = LocationManager.shared.currentLocation?.coordinate else {
            return
        }
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        var bounds = GMSCoordinateBounds(coordinate: location, coordinate: location)
        bounds = bounds.includingCoordinate(currentLocation)
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(50))
        mapView?.animate(with: update)
        
        drawPath(fromLocation: currentLocation,toLocation: location,wayPoints: [])
    }
    
    
    func initVar()  {
        stop = OrderModel()
        stop?.id = 1
        arrIdentifierCells = [identifierEstimateCell,
                              identifierActionCell]
    }
    
    func updateUI()  {
        setupMapView()
    }
    
    func focusToLocation(location:CLLocationCoordinate2D)  {
        let position = GMSCameraPosition(latitude: location.latitude,
                                         longitude: location.longitude,
                                         zoom: 15)
        mapView?.animate(to: position)
    }
    
    @objc func updateStopSuccess(notification:Notification){
        if let data = notification.object as? OrderModel{
            if data.id != stop?.id {
                return
            }
            
            stop = data
            updateUI()
            tbvContent?.reloadData()
        }
    }
    
    func drawPath(fromLocation from: CLLocationCoordinate2D,
                  toLocation to: CLLocationCoordinate2D,
                  wayPoints:Array<CLLocationCoordinate2D>) {
        API.getRouting(origin: from, destination: to, waypoints: wayPoints) { (result) in
            switch result{
            case .object(let obj):
                self.mapDirectionResponse = obj
                for route in obj.routes {
                    let path = GMSPath(fromEncodedPath: route.polyline)
                    let polyLine = GMSPolyline.init(path: path)
                    polyLine.strokeWidth = Constants.ROUTE_WIDTH
                    polyLine.strokeColor = AppColor.primary
                    polyLine.map = self.mapView
                    guard let _path = path else {return}
                    let bounds = GMSCoordinateBounds(path: _path)
                    self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
                }
                break
            case .error(_ ):
                break
            }
        }
    }
}


// MARK: - UITableView
extension StopDetailVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrIdentifierCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = StopDetailInfoRow(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        switch row {
        case .Estimate:
            return cellAddress(tableView: tableView, indexPath: indexPath)
        case .Actions:
            return cellActions(tableView: tableView, indexPath: indexPath)
        }
    }
}


// MARK: - CELL
private extension StopDetailVC {
    func cellAddress(tableView: UITableView, indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierEstimateCell, for: indexPath) as! StopDetailEstimateCell
        cell.configure(delegate: self, order: stop)
        return cell
    }
    
    func cellActions(tableView: UITableView, indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierActionCell, for: indexPath) as! StopDetailActionCell
        cell.delegate = self
        cell.configura(order: stop)
        return cell
    }
}


//MARK: - StopDetailEstimateCellDelegate
extension StopDetailVC:StopDetailEstimateCellDelegate{
    func stopDetailEstimateCell(cell: StopDetailEstimateCell, didSelectEdit btn: UIButton) {
        let vc: NewStopVC = NewStopVC.load(SB: .Stop)
        vc.stop = stop ?? OrderModel()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - StopDetailActionCellDelegate
extension StopDetailVC:StopDetailActionCellDelegate {
    func stopDetailActionCell(cell: StopDetailActionCell, didSelectGoingNext btn: UIButton?) {
        showAlertConfirm(mess: "Your order is on the way and will be there at \(stop?.eta ?? "00:00")",title:"Send ETA",description:"Send the customer a messages to let them know you a on the way")
    }
    
    func stopDetailActionCell(cell: StopDetailActionCell, didSelectCall btn: UIButton?) {
        guard let phoneNumber = stop?.phone else {
            //App().showAlert("Error", "Phone number is empty.")
            return
        }
        
        phoneNumber.makeCall()
    }
    
    func stopDetailActionCell(cell: StopDetailActionCell, didSelectNavigate btn: UIButton?) {
        guard let _order = stop else {
            return
        }
        showMapNavigate(stop: _order)
    }
}



//MARK: - HeaderViewDelegate
extension StopDetailVC:HeaderViewDelegate {
    func headerView(view: HeaderView, didSelectLeftButton btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension StopDetailVC:LocationManagerDelegate{
    func didUpdateLocation(_ location: CLLocation?) {
        //
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
    }
    
}
