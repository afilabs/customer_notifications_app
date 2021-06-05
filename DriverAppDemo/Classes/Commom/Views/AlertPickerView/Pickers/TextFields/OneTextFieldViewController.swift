import UIKit

extension UIAlertController{
    
    func showAlertWithOneTextField(oldData:String? = nil,
                                   isSecureTextEntry:Bool? = false,
                                   onCallback callback: @escaping(_ hasOK:Bool, _ content:String) -> Void ) {
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = "Enter subject..."
            //textField.left(image: image, color: .black)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.isSecureTextEntry = isSecureTextEntry!
            textField.text = oldData
            textField.returnKeyType = .done
            textField.action { textField in
                callback(true,E(textField.text))
            }
        }
        self.addOneTextField(configuration: config)
        self.addAction(title: "OK", style: .cancel)
        self.show()
    }
}

extension UIAlertController {
    
    /// Add a textField
    ///
    /// - Parameters:
    ///   - height: textField height
    ///   - hInset: right and left margins to AlertController border
    ///   - vInset: bottom margin to button
    ///   - configuration: textField
    
    func addOneTextField(configuration: TextField.Config?) {
        let textField = OneTextFieldViewController(vInset: preferredStyle == .alert ? 12 : 0, configuration: configuration)
        let height: CGFloat = OneTextFieldViewController.ui.height + OneTextFieldViewController.ui.vInset
        set(vc: textField, height: height)
    }
}

final class OneTextFieldViewController: UIViewController {
    
    fileprivate lazy var textField: TextField = TextField()
    
    struct ui {
        static let height: CGFloat = 44
        static let hInset: CGFloat = 12
        static var vInset: CGFloat = 12
    }
    
    
    init(vInset: CGFloat = 12, configuration: TextField.Config?) {
        super.init(nibName: nil, bundle: nil)
        view.addSubview(textField)
        ui.vInset = vInset
        
        /// have to set textField frame width and height to apply cornerRadius
        textField.height = ui.height
        textField.width = view.width
        
        configuration?(textField)
        
        preferredContentSize.height = ui.height + ui.vInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textField.width = view.width - ui.hInset * 2
        textField.height = ui.height
        textField.center.x = view.center.x
        textField.center.y = view.center.y - ui.vInset / 2
    }
}
