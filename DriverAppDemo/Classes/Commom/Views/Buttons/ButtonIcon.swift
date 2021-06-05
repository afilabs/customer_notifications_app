//
//  ButtonIcon.swift
//  RouteSimply
//
//  Created by Apple on 4/19/20.
//  Copyright © 2020 NguyenMV. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialRipple

class ButtonIcon: UIView {
    
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var imvLeft:UIImageView?
    @IBOutlet weak var imvRight:UIImageView?
    @IBOutlet weak var vContent:UIView?
    @IBOutlet weak var btnPress:UIButton?
    
    let rippleView = MDCStatefulRippleView()
    
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
        let bundle = Bundle(for: ButtonIcon.self)
        if let view = UINib(nibName: "ButtonIcon", bundle: bundle).instantiate(withOwner: self,
                                                                               options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.translatesAutoresizingMaskIntoConstraints = true
        
            rippleView.setRippleColor(self.backgroundColor?.withAlphaComponent(0.5), for: .selected)
            rippleView.setRippleColor(self.backgroundColor?.withAlphaComponent(0.5), for: .highlighted)
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
        
    var iconRight:UIImage?{
        didSet{
            imvRight?.image = iconRight
        }
    }
    
    var iconLeft:UIImage?{
        didSet{
            imvLeft?.image = iconLeft
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
            rippleView.setRippleColor(rippleColor ?? .lightGray, for: .selected)
            rippleView.setRippleColor(rippleColor ?? .lightGray, for: .highlighted)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      rippleView.touchesBegan(touches, with: event)
      super.touchesBegan(touches, with: event)

      rippleView.isRippleHighlighted = true
      rippleView.isSelected = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      rippleView.touchesMoved(touches, with: event)
      super.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      rippleView.touchesEnded(touches, with: event)
      super.touchesEnded(touches, with: event)

      rippleView.isRippleHighlighted = false
        rippleView.isSelected = false
      self.onPressButton?(btnPress)

    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      rippleView.touchesCancelled(touches, with: event)
      super.touchesCancelled(touches, with: event)
        rippleView.isSelected = false

      rippleView.isRippleHighlighted = false
    }
}
