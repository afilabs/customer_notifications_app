
import UIKit
import SVProgressHUD

extension UIViewController {
    
    public static func load<T>(SB: SBName) -> T {
        return UIStoryboard(name: SB.rawValue,
                            bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: T.self)) as! T;
    }
    
    public static func load<T: UIViewController>(nib: String? = nil) -> T {
        return T(nibName: nib != nil ? nib : String(describing: T.self),
                 bundle: nil);
    }
    
    public func showAlertView(_ message: String, positiveTitle: String? = nil, positiveAction:((_ action: UIAlertAction) -> Void)? = nil, negativeTitle: String? = nil, negativeAction: ((_ action: UIAlertAction) -> Void)? = nil)  {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: isEmpty(positiveTitle) ? "OK".localized : positiveTitle, style: .default, handler: positiveAction)
        if negativeAction != nil {
            let cancelAction = UIAlertAction(title: isEmpty(negativeTitle) ? "Cancel".localized : negativeTitle, style: .cancel, handler: negativeAction)
            alert.addAction(cancelAction)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    
    public static func load<T: UIView>(nib: String? = nil, owner: Any? = nil) -> T {
        return Bundle.main.loadNibNamed(_:nib != nil ? nib! : String(describing: T.self),
                                          owner: owner,
                                          options: nil)?.first as! T;
    }
    
    
}

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}

