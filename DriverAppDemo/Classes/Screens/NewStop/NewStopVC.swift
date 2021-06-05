

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire
import ObjectMapper

class NewStopVC: BaseVC {
    
    @IBOutlet weak var tbvContent:UITableView?


    enum NewStopSection:Int {
       case ContactInfo = 0
       case Address
    }
       
    enum ContactInfoRows:Int {
       case ContactPerson = 0
       case PhoneNumber
    }

    enum AddressInfoRows:Int {
       case Address1 = 0
       case Address2
        
        /*
       case City
       case State
       case ZipCode
        */
    }
    
    struct ValidationCreateStop {
        var validationName = false
        var validationAddress1 = false

        /*
       var validationPhone = false
       var validationCity = false
       var validationState = false
       var validationZipCode = false
         */
    }
    
    
    private let heightHeader = 56
    private let heghtFooter = 100
    private let identifierHeaderCell = "NewStopHeaderCell"
    private let identifierInputCell = "NewStopInputCell"
    private let identifierPhoneNumberCell = "NewStopPhoneNumberCell"
    private let identifierContentCell = "NewStopInputContentCell"
    private let identifierTextViewCell = "StopCompleteInputCell"

    var data:[[String:Any]] = []
    var stop:OrderModel = OrderModel()
    var route_id:String = ""
    var wait_time:Int = 0
    var selectedPlace:GMSPlace?
    
    let section: Alamofire.Session = {
        let smConfig = URLSessionConfiguration.af.default
        smConfig.timeoutIntervalForRequest = 30;
        return Alamofire.Session(configuration: smConfig)
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDataDisplay()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func setupHeaaderView() {
        super.setupHeaaderView()
        headerView?.delegate = self
        headerView?.setHeaderView(type: .backOnly, title: "Customer")
    }
    
    
    //MARK: -ACTIONS
    @IBAction func onbtnClickSave(btn:UIButton){
        if validStop() {
            updateStop(stop: stop)
        }
    }
    
    func setupDataDisplay()  {
        data = [
            //Contact section
            ["title_header":"Contact Info",
             "rows":[["title":"Contact Person","content":E(stop.name),"placeholder":"John Appleseed"],
                     ["title":"Phone Number","content":E(stop.phone),"placeholder":"Optional"]]
            ],
             //Address section
             ["title_header":"Address",
              "rows":[["title":"Address Line 1","content":E(stop.address1),"placeholder":"Required"],
                      ["title":"Address Line 2","content":E(stop.address2),"placeholder":"Optional"]]

             ]
            ]
    }
    
    func setupTableView()  {
        tbvContent?.delegate = self
        tbvContent?.dataSource = self
    }
    
    
    // Present the Autocomplete view controller when the button is pressed.
    func showGooglePlaceAutocomplete()  {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    GMSPlaceField.formattedAddress.rawValue |
                                                    GMSPlaceField.coordinate.rawValue)

        autocompleteController.placeFields = fields

        if let location = LocationManager.shared.currentLocation {
            /*
            autocompleteController.autocompleteBounds = GMSCoordinateBounds(coordinate: location.coordinate,
                                                                            coordinate: location.coordinate)
             */
        }
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func getValues() -> [String] {
        let data:[String] = ["No Waiting Time","30 Minutes","60 Minutes","120 Minutes"]
        /*
          let step = 15
          var start = 15
          let end = 8 * 60 // Max is 8 hours

          while start < end {
              start = start + step
              data.append("\(start) Minutes")
          }
        */
        return data
    }

}

//MMARK: - API
extension NewStopVC {
    func updateStop(stop:OrderModel)  {
        var params:[String:Any] = ["name":stop.name ?? "",
                                   "address":stop.address1 ?? "",
                                   "phone": stop.phone ?? "",
                                   "lat":stop.lat,
                                   "lng":stop.long]
        
        if let currentLocation = LocationManager.shared.currentLocation?.coordinate {
            params["driverLat"] = currentLocation.latitude
            params["driverLng"] = currentLocation.longitude
            params["driverTimezone"] = TimeZone.current.identifier
        }
    
        let url = "https://customer-notifications-sample.herokuapp.com/stops/\(stop.id)"
        
        print("updateStop() in NewStopVC called")
        
        App().showLoading()
        section.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).responseJSON {[weak self] (response) in
            App().dismissLoading()
            switch response.result{
            case .success(let obj):
                print("==>ResponseJSON:\(obj)")
                //Mapping JSON to OrderModel
                if let dictionary = obj as? [String: Any],
                   let order = Mapper<OrderModel>().map(JSON: dictionary) {
                    self?.stop = order
                    NotificationCenter.default.post(name: .updateStopSuccessfully, object: order, userInfo: nil)
                    self?.navigationController?.popViewController(animated: true)
                    
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
        
        /*
        API.updateStop(id: stop.id, params: params) { (result) in
            App().dismissLoading()
            switch result{
            case .object(let _stop):
                self.stop = _stop
                self.stop.id = stop.id
                NotificationCenter.default.post(name:  .updateStopSuccessfully,
                                                object: self.stop, userInfo: nil)
                self.navigationController?.popViewController(animated: true)
                break
            case .error( let error):
                App().showAlert("Error", error.message ?? "")
                break
            }
        }
         */
    }
}


//MARK: - UITableViewDataSource
extension NewStopVC:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = data[section]["rows"] as? [[String:Any]] {
            return rows.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: identifierHeaderCell) as! NewStopHeaderCell
        let title = data[section]["title_header"] as? String
        header.configura(title: title)
        
        let view = UIView()
        header.frame = CGRectMake(0, 0, header.frame.size.width, 56)
        view.addSubview(header)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row

        guard let newStopSection = NewStopSection(rawValue: section) else {
             return UITableViewCell()
        }
        
        switch newStopSection {
        case .ContactInfo:
            if row == ContactInfoRows.PhoneNumber.rawValue {
                return phoneNumberCell(tableView: tableView, indexPath: indexPath)
            }
            return newStopInputCell(tableView: tableView, indexPath: indexPath)
            
        case .Address:
            if row == AddressInfoRows.Address1.rawValue  {
                return newStopInputContentCell(tableView: tableView, indexPath: indexPath)
            }
            return newStopInputCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if (section == NewStopSection.Address.rawValue &&
            row == AddressInfoRows.Address1.rawValue) {
            showGooglePlaceAutocomplete()
            
        }
    }
}

//MARK: - CELLS
extension NewStopVC{
    func newStopInputCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let keyboardType = UIKeyboardType.default
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierInputCell, for: indexPath) as! NewStopInputCell
        if let rows = data[section]["rows"] as? [[String:Any]]{
            let rowData = rows[row]
            cell.configura(title: rowData["title"] as? String,
                           content: rowData["content"] as? String,
                           placeholder: rowData["placeholder"] as? String,
                           keyboardType: keyboardType)
            cell.delegate = self
        }
                
        return cell
    }
    
    func newStopInputContentCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierContentCell, for: indexPath) as! NewStopInputContentCell
        if let rows = data[section]["rows"] as? [[String:Any]]{
            let rowData = rows[row]
            cell.configura(title: rowData["title"] as? String,
                           content: rowData["content"] as? String,
                           placeholder: rowData["placeholder"] as? String)
        }
                
        return cell
    }
    
    
    func newStopAddressCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let identifier = row == AddressInfoRows.Address1.rawValue ? identifierContentCell : identifierInputCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NewStopInputCell
        if let rows = data[section]["rows"] as? [[String:Any]]{
            let rowData = rows[row]
            cell.configura(title: rowData["title"] as? String,
                           content: rowData["content"] as? String,
                           placeholder: rowData["placeholder"] as? String)
            cell.delegate = self
        }
                
        return cell
    }
    
    func phoneNumberCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierPhoneNumberCell)
        as! PhoneNumberCell
        cell.delegate = self
        cell.configura(title: "Phone Number",
                       content: E(stop.phone),
                       placeholder: "Optional")
        
 
        return cell
    }
}


//MARK: - HeaderViewDelegate
extension NewStopVC:HeaderViewDelegate{
    func headerView(view: HeaderView, didSelectLeftButton btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - PhoneNumberCell
extension NewStopVC:PhoneNumberCellDelegate {
    func phoneNumberCell(cell: PhoneNumberCell, onChangeText text: String) {
        stop.phone = text
    }
    
    func phoneNumberCell(cell: PhoneNumberCell, textFieldDidBeginEditing textField: UITextField) {
        //
    }
}


//MARK: - NewStopInputCellDelegate
extension NewStopVC:NewStopInputCellDelegate{
    func newStopInputCell(cell: NewStopInputCell, textFieldDidBeginEditing textField: UITextField) {
     //
    }
    
    func newStopInputCell(cell: NewStopInputCell, onChangeText text: String) {
        guard let indexPath = tbvContent?.indexPath(for: cell),
            let newStopSection = NewStopSection(rawValue: indexPath.section) else {
           return
        }

        switch newStopSection {
        case .ContactInfo:
            switch indexPath.row {
            case ContactInfoRows.ContactPerson.rawValue:
                //validationCreateStop.validationName = !isEmpty(text)
                stop.name = text
                break
            default:
                break
            }
            
          break
           
        case .Address:
            
            switch indexPath.row {
            case AddressInfoRows.Address1.rawValue:
                stop.address1 = text
                break
            case AddressInfoRows.Address2.rawValue:
                stop.address2 = text
                break
            default:
              break
            }
            break
        }
        setupDataDisplay()
    }
}


//MARK: - HEPPERs
extension NewStopVC{
    func validStop() -> Bool {
        if !isEmpty(stop.phone) && !stop.isValidPhoneNumber{
            App().showAlert("Invalid", "Phone number is invalid.")
            return false
        }
        
        if isEmpty(stop.address1){
            App().showAlert("Invalid Address", "Please type an valid address.")
            return false
        }
        
        return true
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate
extension NewStopVC: GMSAutocompleteViewControllerDelegate {
      // Handle the user's selection.
      func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("===>Selected place:\(convertPlaceToJSON(place))")
        
        selectedPlace = place
        stop.address1 = place.formattedAddress
        stop.lat = place.coordinate.latitude
        stop.long = place.coordinate.longitude
        setupDataDisplay()
        tbvContent?.reloadData()
        dismiss(animated: true, completion: nil)
      }
    
      func convertPlaceToJSON(_ place:GMSPlace) -> [String:Any] {
        var data:[String:Any] = [:]
        data["name"] = place.name
        data["placeID"] = place.placeID
        data["coordinate"] = place.coordinate
        data["phoneNumber"] = place.phoneNumber
        data["formattedAddress"] = place.formattedAddress
        data["rating"] = place.rating
        data["priceLevel"] = place.priceLevel
        data["types"] = place.types
        data["website"] = place.website
        data["userRatingsTotal"] = place.userRatingsTotal
        data["openingHours"] = place.openingHours
        return data
      }

      func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
      }

      // User canceled the operation.
      func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
      }

      // Turn the network activity indicator on and off again.
      func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }

      func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
}
