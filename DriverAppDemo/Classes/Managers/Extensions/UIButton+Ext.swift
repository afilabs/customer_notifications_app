
import UIKit;

extension UIButton {
    
    // MARK: - IBInspectable
    @IBInspectable var localizeKey: String {
        get {
            return ""
        } set {
            self.setTitle(newValue.localized, for: .normal)
        }
    }
    
    
    // MARK: - Util properties
    
    var title: String? {
        get {
            return title(for: .normal);
        }
        set {
            setTitle(newValue, for: .normal);
        }
    }
    
    var titleColor: UIColor? {
        get {
            return titleColor(for: .normal);
        }
        set {
            setTitleColor(newValue, for: .normal);
        }
    }
    
    var attrTitle: NSAttributedString? {
        get {
            return attributedTitle(for: .normal);
        }
        set {
            setAttributedTitle(newValue, for: .normal);
        }
    }
    
    var image: UIImage? {
        get {
            return image(for: .normal);
        }
        set {
            setImage(newValue, for: .normal);
        }
    }
    
    var backgroundImage: UIImage? {
        get {
            return backgroundImage(for: .normal);
        }
        set {
            setBackgroundImage(newValue, for: .normal);
        }
    }
    
    // MARK: -
    func setShadow(shadowOpacity: CGFloat,shadowOffset: CGSize,shadowRadius: CGFloat,shadowColor: UIColor){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
    
    func setImageWithURL(url:String?,
                         name:String? = nil,
                         placeHolderImage:UIImage? = nil,
                         complateDownload:((UIImage?,Error?)-> Void)? = nil)  {
        
        if url != nil {
            let _url = url?.encodeURL()
            self.sd_setImage(with: URL(string: _url!), for: .normal) { (image, error, cache, url) in
                complateDownload?(image,error)
            }
            
        } else {
            self.title = CommonUtils.getTwoFirstLetter(string:E(name))
            self.backgroundColor = AppColor.failedStatus.withAlphaComponent(0.2)
            self.setTitleColor(AppColor.failedStatus, for: .normal)
            self.circleCorner = true
            self.setImage(nil, for: .normal)
            self.setImage(nil, for: .selected)
        }
    }
}


//MARK: -Style
extension UIButton{
    
    func setPrimaryStyleButton()  {
        self.cornerRadius = 8
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = AppColor.primary
    }
    
    
}
