//
//  BaseVC.swift
//  RouteSimply
//
//  Created by Apple on 12/21/19.
//  Copyright © 2019 NguyenMV. All rights reserved.
//

import UIKit
import Reachability

class BaseVC: UIViewController {
    
    private var gesDismissKeyboardDetector : UITapGestureRecognizer? = nil;
    private var obsKeyboardChangeFrame: NSObjectProtocol? = nil;
    
    let reachability = try! Reachability()
    var isContectedNetwork = true  {
        didSet{
            contectNetworkDidChanged(staus: reachability.connection)
        }
    }
    
    @IBOutlet weak var headerView:HeaderView?
    @IBOutlet weak var conHightTrialDayLeft:NSLayoutConstraint?


    override func viewDidLoad() {
        super.viewDidLoad()
        //App().statusBarUIView?.backgroundColor = UIColor(hex: Color.background)
        navigationController?.interactivePopGestureRecognizer?.delegate = self;
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupReachability()  {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func setupUI() {
        setupHeaaderView()
        conHightTrialDayLeft?.constant = 0
    }
    
    
    func setupHeaaderView()  {
        headerView?.backgroundColor = .clear
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
      let reachability = note.object as! Reachability
      switch reachability.connection {
      case .wifi:
          print("Reachable via WiFi")
          isContectedNetwork = true
      case .cellular:
          print("Reachable via Cellular")
          isContectedNetwork = true
      case .none:
          print("Network not reachable")
          isContectedNetwork = false
        
      default:
        break
        }
    }
    
    func contectNetworkDidChanged(staus: Reachability.Connection) {
        //
    }

}

extension BaseVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


// MARK: - Keyboard
extension BaseVC{
    
    final func registerForKeyboardNotifications() {
        
        guard obsKeyboardChangeFrame == nil else {
            return;
        }
        
        obsKeyboardChangeFrame =
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main,
                                                   using: keyboardWillChangeFrame(noti:))
    }
    
    final func unregisterForKeyboardNotifications() {
        
        guard let obs = obsKeyboardChangeFrame else {
            return;
        }
        
        obsKeyboardChangeFrame = nil;
        NotificationCenter.default.removeObserver(obs);
    }
    
    final func addDismissKeyboardDetector() {
        
        guard gesDismissKeyboardDetector == nil else {
            return;
        }
        
        gesDismissKeyboardDetector = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(tapGesture:)));
        gesDismissKeyboardDetector?.delegate = self
        
        self.view.addGestureRecognizer(gesDismissKeyboardDetector!);
    }
    
    final func removeDismissKeyboardDetector() {
        
        guard let ges = gesDismissKeyboardDetector else {
            return;
        }
        
        gesDismissKeyboardDetector = nil;
        self.view.removeGestureRecognizer(ges);
        
    }
    
    func keyboardWillChangeFrame(noti: Notification) {}
    
    @objc func dismissKeyboard(tapGesture: UITapGestureRecognizer?) {
        self.view.endEditing(true);
    }
    
    func getKeyboardHeight(noti:NSNotification) -> CGFloat {
        
        let userInfo:NSDictionary = noti.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        return keyboardHeight;
    }
}
