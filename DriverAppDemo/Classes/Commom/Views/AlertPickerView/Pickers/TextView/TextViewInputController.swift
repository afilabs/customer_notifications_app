import UIKit

extension UIAlertController {
    
    /// Add a Text Viewer
    ///
    /// - Parameters:
    ///   - text: text kind    
    func showTextViewInput(placeholder:String,
                           nameAction:String,
                           oldText: String,
                           onCallback callback: @escaping(_ hasOK:Bool, _ content:String) -> Void ){
        
        let textView = TextViewInputViewController(text: .text(oldText,placeholder))
        set(vc: textView)
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel) { action in
            //
        }
        let doneAction = UIAlertAction(title: nameAction.localized, style: .default) { (ok) in
            callback(true, textView.textViewInput.tvContent?.text ?? "")
        }
        
        self.addAction(cancelAction)
        self.addAction(doneAction)
        textView.actionOK = doneAction
        
        self.show()
    }
}

final class TextViewInputViewController: UIViewController, TextViewInputDelegate {
    
    enum Kind {
        
        case text(String?,String?)
        case attributedText([AttributedTextBlock])
    }
    
    var enable: Bool = false {
        didSet{
            actionOK?.isEnabled = enable
        }
    }

    var actionOK:UIAlertAction?
    fileprivate var text: [AttributedTextBlock] = []
    fileprivate let textViewInput:TextViewInput = TextViewInput.load()
    
    
    struct UI {
        static let height: CGFloat = UIScreen.main.bounds.height * 0.7
        static let vInset: CGFloat = 5
        static let hInset: CGFloat = 16
        static let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    init(text kind: Kind) {
        super.init(nibName: nil, bundle: nil)
        switch kind {
        case .text(let text, let placeholder):
            textViewInput.tvContent?.text = text
            textViewInput.lblPlaceholder?.isHidden = !isEmpty(text)
            textViewInput.lblPlaceholder?.text = placeholder
            
        case .attributedText(let text):
            textViewInput.tvContent?.attributedText = text.map { $0.text }.joined(separator: "\n")
        }
        textViewInput.tvContent?.textContainerInset = UIEdgeInsets(top: UI.hInset, left: UI.vInset, bottom: UI.hInset, right: UI.vInset)
        preferredContentSize.height = MAX(80,textViewInput.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func loadView() {
        view = textViewInput
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredContentSize.width = UIScreen.main.bounds.width * 0.7
        }
        setupButtonClear()
        textViewInput.delegate = self
    }
    
    func setupButtonClear() {
        let frame = CGRectMake(0, 0, 15, 15)
        
        let button = UIButton()
        button.frame = frame
        button.setImage(#imageLiteral(resourceName: "ic_cancel_gray"), for: .normal)
        button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        textViewInput.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonRightCS = NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: textViewInput.tvContent, attribute: .trailing, multiplier: 1.0, constant: -10)
        
        let buttonTopCS = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: textViewInput.tvContent, attribute: .top, multiplier: 1.0, constant: 10)
        
        let widthBtn = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 15)
        
        let heightBtn = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 15)
        
        
        textViewInput.addConstraints([buttonRightCS, buttonTopCS, widthBtn, heightBtn])
    }
    
    @objc func clearText() {
        textViewInput.tvContent?.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textViewInput.tvContent?.scrollToTop()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize.height = MAX(100, textViewInput.frame.height)

    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text ?? "")
        if textView.text != "" {
            enable = true
        } else {
            enable = false
        }
    }
}
