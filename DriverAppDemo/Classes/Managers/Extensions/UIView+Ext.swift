
import UIKit

// MARK: - Designable Extension
@IBDesignable
extension UIView {
    
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
            clipsToBounds = true
            //abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}

// MARK: - Properties

public extension UIView {
    
    /// Size of view.
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
    /// Width of view.
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    /// Height of view.
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}


// MARK: - Finding
extension UIView {
    
    func findNextResponder(withClass cls : AnyClass) -> UIResponder? {
        
        var current : UIResponder? = self;
        
        while let aCurrent = current {
            
            if aCurrent.isKind(of: cls) {
                return current;
            }
            
            current = aCurrent.next;
        }
        
        return nil;
    }
    
    func getSuperView(withClass cls: AnyClass) -> Any? {
        
        var obj = self.superview;
        
        while let anObj = obj {
            
            if anObj.isKind(of: cls) {
                return anObj;
            }else{
                obj = anObj.superview;
            }
            
        }
        
        return nil;
    }
    
    // MARK: - Style
    
    func addShadow(radius: CGFloat, shadowOffset: CGSize, alpha: CGFloat ) {
        layer.cornerRadius = radius
        layer.shadowOffset = shadowOffset
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }

    func addShadow(color: UIColor, x: CGFloat, y: CGFloat, blur: CGFloat) {
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = blur
    }
    
    func setBorder(color: UIColor?, lineW: CGFloat) {
        self.layer.borderColor = color?.cgColor;
        self.layer.borderWidth = lineW;
    }
    
    func setRoudary(radius: CGFloat) {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        self.clipsToBounds = true
    }
    
    // MARK: - Others
    
    func removeAllConstraints() {
        removeConstraints(self.constraints);
    }
    
    func removeAllConstraintsIncludesSubviews() {
        removeAllConstraints();
        
        for subView in self.subviews {
            subView.removeAllConstraintsIncludesSubviews();
        }
        
    }
    
    func addSubview(_ subView: UIView, edge: UIEdgeInsets) {
    
        let frame = self.bounds.inset(by: edge);
        subView.frame = frame;
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        addSubview(subView);
    }
    
    func addConstaints(top: CGFloat? = nil,
                       right: CGFloat? = nil,
                       bottom: CGFloat? = nil,
                       left: CGFloat? = nil,
                       width: CGFloat? = nil,
                       height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if top != nil { self.addConstaint(top: top!) }
        if right != nil { self.addConstaint(right: right!) }
        if bottom != nil { self.addConstaint(bottom: bottom!) }
        if left != nil { self.addConstaint(left: left!) }
        if width != nil { self.addConstaint(width: width!) }
        if height != nil { self.addConstaint(heigh: height!) }

    }
    
    func addConstaint(top offset: CGFloat) {
        guard superview != nil else { return }
        topAnchor.constraint(equalTo: superview!.topAnchor, constant: offset).isActive = true
    }
    
    func addConstaint(right offset: CGFloat) {
        guard superview != nil else { return }
        rightAnchor.constraint(equalTo: superview!.rightAnchor, constant: offset).isActive = true
    }
    
    func addConstaint(left offset: CGFloat) {
        guard superview != nil else { return }
        leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: offset).isActive = true
    }
    
    func addConstaint(bottom offset: CGFloat) {
        guard superview != nil else { return }
        bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: offset).isActive = true
    }
    
    func addConstaint(width offset: CGFloat) {
        guard superview != nil else { return }
        widthAnchor.constraint(equalTo: superview!.widthAnchor, constant: offset).isActive = true
    }
    func addConstaint(heigh offset: CGFloat) {
        guard superview != nil else { return }
        heightAnchor.constraint(equalTo: superview!.heightAnchor, constant: offset).isActive = true
    }
    
    
    func capture() -> UIImage? {
        return capture(scale: 0.0);
    }
    
    func capture(scale: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, scale);
        
        drawHierarchy(in: self.frame, afterScreenUpdates: true);
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func setShadowDefault() {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
    }
    
    func setShadowWithColor(_ color: UIColor) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 7
    }
    
    func setShadowButton() {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
    }
    
    enum ViewSide {
        case left, right, top, bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
        case .bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        }
        
        layer.addSublayer(border)
    }
}

extension UIView {
    
    func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = 1.0) {
        
        func createBorder() -> UIView {
            let borderView = UIView(frame: CGRect.zero)
            borderView.translatesAutoresizingMaskIntoConstraints = false
            borderView.backgroundColor = color
            borderView.maskToBounds = true
            borderView.clipsToBounds = true
            return borderView
        }
        
        if (edges.contains(.all) || edges.contains(.top)) {
            let topBorder = createBorder()
            self.addSubview(topBorder)
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: self.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                topBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.left)) {
            let leftBorder = createBorder()
            self.addSubview(leftBorder)
            NSLayoutConstraint.activate([
                leftBorder.topAnchor.constraint(equalTo: self.topAnchor),
                leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.right)) {
            let rightBorder = createBorder()
            self.addSubview(rightBorder)
            NSLayoutConstraint.activate([
                rightBorder.topAnchor.constraint(equalTo: self.topAnchor),
                rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.bottom)) {
            let bottomBorder = createBorder()
            self.addSubview(bottomBorder)
            NSLayoutConstraint.activate([
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                bottomBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
    }
    
    func styleShadowTop() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 2)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func makeSnapshot() -> UIView {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIView()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        // Tạo style cho snapshot view nổi bật hơn
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
}

extension UIView{
    
    @discardableResult
    class func addViewNoItemWithTitle(_ title:String,intoParentView parentView:UIView) -> UIView{
        removeViewNoItemAtParentView(parentView)
        
        let view = UIView(frame: CGRectMake(0, 0, parentView.frame.size.width/2, 70))
        view.isUserInteractionEnabled = false
        let imv = UIImageView(frame: CGRectMake(0, 5, view.frame.size.width, 25))
        imv.image = UIImage(named: "ic-NoImageGray")
        imv.contentMode = .scaleAspectFit
        view.addSubview(imv)
        
        let lbl = UILabel(frame: CGRectMake(0, 45, view.frame.size.width, 20))
        lbl.text = title
        lbl.textAlignment = .center
        lbl.textColor = AppColor.grayColor
        view.addSubview(lbl)
        view.center = parentView.center
        view.tag = 1000
        
        parentView.addSubview(view)
        
        return view
    }
    
    
    class func removeViewNoItemAtParentView(_ parentView:UIView)  {
        let view = parentView.viewWithTag(1000)
        view?.removeFromSuperview()
    }
}

extension UIStackView {
    func addBackgroundColor(_ color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        insertSubview(subView, at: 0)
    }
}
