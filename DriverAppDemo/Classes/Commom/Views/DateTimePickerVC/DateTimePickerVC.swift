
import UIKit


typealias  DateTimePickerCallback = (_ date:Date) -> Void
typealias  DateTimePickerFromToCallback = (_ from:Date, _ to:Date) -> Void
typealias  HourPickerFromToCallback = (_ from:Int, _ to:Int) -> Void


class DateTimePickerVC: BaseVC {
    
    @IBOutlet weak var tbvContent:UITableView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var btnCancel:UIButton?
    @IBOutlet weak var btnDone:UIButton?
    @IBOutlet weak var btnArrowDown:UIButton?
    @IBOutlet weak var btnArrowUp:UIButton?
    @IBOutlet weak var datePicker:UIDatePicker?
    @IBOutlet weak var fromDatePicker:UIDatePicker?
    @IBOutlet weak var toDatePicker:UIDatePicker?
    @IBOutlet weak var fromHourPicker:UIPickerView?
    @IBOutlet weak var toHourPicker:UIPickerView?
    @IBOutlet weak var viewContentDatePicker:UIView?
    @IBOutlet weak var viewContentPickerFromTo:UIView?

    fileprivate let identifierCell = "DatePickerTimeCell"
    fileprivate let identifierHourOnlyCell = "PickerHourCell"

    fileprivate var fromDate:Date?
    fileprivate var toDate:Date?
    fileprivate var minDate:Date?
    fileprivate var maxDate:Date?
    fileprivate var currentDate:Date?


    var callback:DateTimePickerCallback?
    var callbackFromTo:DateTimePickerFromToCallback?
    var callbackFromToHourOnly:HourPickerFromToCallback?

    var mode:UIDatePicker.Mode = .date
    
    var modeHourOnly = false
    var fromHour = 1
    var toHour = 1


    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addDismissKeyboardDetector()
        showDatePickerWithAnimation()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeDismissKeyboardDetector()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        self.tbvContent?.delegate = self
        self.tbvContent?.dataSource = self
    }
    
    func updateUI() {
        setupDatePicker()
        setupTableView()
        btnCancel?.roundCorners([.bottomLeft], radius: 5)
        btnDone?.roundCorners([.bottomRight], radius: 5)
    }
    
    func setupDatePicker() {
        datePicker?.datePickerMode = mode
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = maxDate
        datePicker?.date = currentDate ?? Date.now
        datePicker?.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    @objc func showDatePickerWithAnimation()  {
        let height = viewContentDatePicker?.frame.size.height ?? 0
        
        viewContentDatePicker?.transform = CGAffineTransform(translationX: 0, y: height)
        UIView.animate(withDuration: 0.25) {
            self.viewContentDatePicker?.transform = .identity
        }
    }
    
    func hiddenPicker()  {
        let height = viewContentDatePicker?.frame.size.height ?? 0
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.viewContentDatePicker?.transform = CGAffineTransform(translationX: 0, y: height)
        }) {[weak self] (isFinish) in
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func datePickerChanged(picker: UIDatePicker){
        print("Date Change:\(picker.date)")
    }
    
    override func dismissKeyboard(tapGesture: UITapGestureRecognizer?) {
        hiddenPicker()
    }
    
    //  MARK: - ACTION
    @IBAction func onbtnClickArrowDown(btn:UIButton){
        
    }
    
    @IBAction func onbtnClickArrowUp(btn:UIButton){
        
    }
    
    @IBAction func onbtnClickCancel(btn:UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onbtnClickOK(btn:UIButton){
        self.dismiss(animated: false, completion: {
            if self.modeHourOnly {
                self.callbackFromToHourOnly?(self.fromHour,self.toHour)
                
            }else {
                if let from = self.fromDatePicker?.date,
                    let to = self.toDatePicker?.date {
                    self.callbackFromTo?(from,to)
                }
            }
        })
    }
    
    @IBAction func onbtnClickDone(btn:UIButton){
        hiddenPicker()
        if let date = self.datePicker?.date {
            self.callback?(date)
        }
    }
}


//MARK: - UITableViewDataSource
extension DateTimePickerVC:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !modeHourOnly {
            let cell = tbvContent?.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath) as! DatePickerTimeCell
            cell.fromDatePicker?.datePickerMode = mode
            cell.toDatePicker?.datePickerMode = mode
            self.fromDatePicker = cell.fromDatePicker
            self.toDatePicker = cell.toDatePicker

            return cell
            
        }else {
            let cell = tbvContent?.dequeueReusableCell(withIdentifier: identifierHourOnlyCell, for: indexPath) as! PickerHourCell
            cell.delegate = self
            cell.configura(oldData: (fromHour,toHour))
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

//MARK: - PickerHourCellDelegate
extension DateTimePickerVC:PickerHourCellDelegate{
    func pickerHourCell(cell: PickerHourCell, didSelectRow value: (from: Int, to: Int)) {
        toHour = value.to
        fromHour = value.from
    }
}

//MARK: - Help Funtion
extension DateTimePickerVC{
    
    static func showDatePicker(_ pickerMode:UIDatePicker.Mode,
                               curentDate:Date = Date.now,
                               minDate:Date? = nil,
                               maxDate:Date? = nil,
                               callback:@escaping DateTimePickerCallback){
        
        let vc:DateTimePickerVC = DateTimePickerVC.load(SB: .Commons)
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0);
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.minDate = minDate
        vc.maxDate = maxDate
        vc.currentDate = curentDate
        vc.setCallBack(callback: callback)
        vc.setPickerMode(pickerMode)
        
        //App().homeVC?.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    static func showDatePicker(_ pickerMode:UIDatePicker.Mode,
                               _ from:Date = Date.now,
                               _ to:Date = Date.now,
                               _ callback:@escaping DateTimePickerFromToCallback){
        
        let vc:DateTimePickerVC = DateTimePickerVC.load(SB: .Commons)
        vc.setCallBack(callback: callback)
        vc.setPickerMode(pickerMode)
        
        //App().homeVC?.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    static func showHourOnlyPicker(_ from:Int = 1,
                               _ to:Int = 1,
                               _ callback:@escaping HourPickerFromToCallback){
        
        let vc:DateTimePickerVC = DateTimePickerVC.load(SB: .Commons)
        vc.setCallBack(callback: callback)
        vc.modeHourOnly = true
        vc.fromHour = from
        vc.toHour = to
       // App().homeVC?.navigationController?.present(vc, animated: true, completion: nil)
    }
}

//MARK: - OtherFuntion
fileprivate extension DateTimePickerVC{
    
    func setCallBack(callback:@escaping DateTimePickerCallback)  {
        self.callback = callback
    }
    func setCallBack(callback:@escaping DateTimePickerFromToCallback)  {
        self.callbackFromTo = callback
    }
    
    func setCallBack(callback:@escaping HourPickerFromToCallback)  {
        self.callbackFromToHourOnly = callback
    }
    
    func setPickerMode(_ pickerMode: UIDatePicker.Mode) {
        self.mode = pickerMode
        setupDatePicker()
    }
}
