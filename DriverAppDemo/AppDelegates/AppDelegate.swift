//
//  AppDelegate.swift
//  DriverAppDemo
//
//  Created by Apple on 4/1/21.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        navigationToWelcomeOrAppContainer()
        // Setup Google Maps
        GMSServices.provideAPIKey(Network.googleAPIKey)
        GMSPlacesClient.provideAPIKey(Network.googleAPIKey)

        // Use Firebase library to configure APIs
        FirebaseApp.configure()

        LocationManager.shared.requestLocation()
        App().statusBarUIView?.backgroundColor = .clear
        return true
    }
}





extension AppDelegate{
    func navigationToWelcomeOrAppContainer() {
        loginSuccessfully()

        /*
        if Caches().hasLogin {
             loginSuccessfully()
         }else {
            logOut()
         }
         */
     }
     
     func setRootViewController(vc:UIViewController)  {
         window?.rootViewController = vc
     }
     
     func loginSuccessfully() {
        let mainVC: MainVC = MainVC.load(SB: .Main)
        let nv =  UINavigationController(rootViewController: mainVC)
        nv.isNavigationBarHidden = true
        window?.rootViewController = nv
    }
    
    func logOut() {
        //
    }
    
    func showAlert(_ title:String? ,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if let viewController = window?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func showAlertView(_ title:String? = nil, _ message: String? = nil,
                       positiveTitle: String? = nil,
                       positiveAction:((_ action: UIAlertAction) -> Void)? = nil,
                       negativeTitle: String? = nil,
                       negativeAction: ((_ action: UIAlertAction) -> Void)? = nil)  {
        let alert = UIAlertController(title: E(title), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: isEmpty(positiveTitle) ? "OK".localized : positiveTitle, style: .default, handler: positiveAction)
        if negativeAction != nil {
            let cancelAction = UIAlertAction(title: isEmpty(negativeTitle) ? "Cancel".localized : negativeTitle, style: .cancel, handler: negativeAction)
            alert.addAction(cancelAction)
        }
        alert.addAction(okAction)
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    var statusBarUIView: UIView? {
      if #available(iOS 13.0, *) {
          let tag = 38482
          let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

          if let statusBar = keyWindow?.viewWithTag(tag) {
              return statusBar
          } else {
              guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
              let statusBarView = UIView(frame: statusBarFrame)
              statusBarView.tag = tag
              keyWindow?.addSubview(statusBarView)
              return statusBarView
          }
      } else if responds(to: Selector(("statusBar"))) {
          return value(forKey: "statusBar") as? UIView
      } else {
          return nil
      }
    }
    
    func showLoading()  {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show()
        }
    }
    
    func dismissLoading()  {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}

