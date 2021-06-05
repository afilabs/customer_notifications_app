//
//  ButtonIconOverText.swift
//  RouteSimply
//
//  Created by Apple on 5/2/20.
//  Copyright © 2020 NguyenMV. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialRipple

class ButtonIconOverText: UIView {
    
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var imvIcon:UIImageView?
    @IBOutlet weak var vContent:UIView?
    @IBOutlet weak var btnPress:UIButton?
    
    let rippleView = MDCRippleView()
    
    private var onPressButton:((UIButton?)->())?


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setupView()  {
        let bundle = Bundle(for: ButtonIconOverText.self)
        if let view = UINib(nibName: "ButtonIconOverText", bundle: bundle).instantiate(withOwner: self,
                                                                               options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.translatesAutoresizingMaskIntoConstraints = true
        
            rippleView.rippleColor = self.backgroundColor?.withAlphaComponent(0.6) ?? .lightGray
            rippleView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            
            addSubview(rippleView)
            addSubview(view)

            initUI()
        }
    }
    
    func initUI()   {
        self.cornerRadius = 8
    }
    
    
    //MARK:- SETUP
    var title:String?{
        didSet{
            lblTitle?.text = title
        }
    }
    
    var titleColor:UIColor?{
        didSet{
            lblTitle?.textColor = titleColor
        }
    }
        
    var icon:UIImage?{
        didSet{
            imvIcon?.image = icon
        }
    }
    
    var onPress:((UIButton?)->())?{
        didSet{
            onPressButton = onPress
        }
    }
    
    var isEnabled:Bool? {
        didSet{
            self.alpha = (isEnabled  ?? true) ? 1 : 0.3
            btnPress?.isEnabled = isEnabled  ?? true
        }
    }
    
    var rippleColor:UIColor?{
        didSet{
            rippleView.rippleColor = rippleColor ?? .lightGray
        }
    }
    
    @IBAction func beginRippleTouchDown(btn:UIButton){
        rippleView.beginRippleTouchDown(at: btn.frame.origin,
                                        animated: true,
                                        completion: nil)
    }
    
    @IBAction func beginRippleTouchUp(btn:UIButton){
        rippleView.beginRippleTouchUp(animated: true, completion: {[unowned self] in
            self.onPressButton?(btn)
        })
    }
    
    @IBAction func beginRippleTouchEnd(btn:UIButton){
        rippleView.beginRippleTouchUp(animated: true, completion: {
        })
    }
    
    @IBAction func beginRippleTouchDragOutsite(btn:UIButton){
        rippleView.beginRippleTouchUp(animated: true, completion: {
        })
    }
    
}
