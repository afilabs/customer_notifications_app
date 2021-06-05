//
//  BlueButton.swift
//  RouteSimply
//
//  Created by Apple on 12/22/19.
//  Copyright © 2019 NguyenMV. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialRipple

class BlueButton: UIButton {
    
    let rippleView = MDCStatefulRippleView()


    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.setTitleColor(.white, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = AppColor.blueButton
        //rippleView.rippleColor = UIColor(hex: Color.blueButton, alpha: 0.5)
        rippleView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        rippleView.setRippleColor(.lightGray,
                                  for: .selected)
        rippleView.setRippleColor(.lightGray,
                                  for: .highlighted)
        addSubview(rippleView)
    }
    
    @IBInspectable var imageRight:UIImage? {
         didSet{
             self.image = imageRight
            let widthText = self.title?.getWidth(font: UIFont.systemFont(ofSize: 16)) ?? 0
             let xImage = (self.frame.width - widthText) / 2
             
             self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                 left: widthText + xImage + 10,
                                                 bottom: 0, right: 0)
             self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: 0, right: 50)
         }
     }
     
     @IBInspectable var imageLeft:UIImage?{
         didSet{
             self.image = imageLeft
             let widthText = self.title?.getWidth(font: UIFont.systemFont(ofSize: 16)) ?? 0
             let xImage = (self.frame.width - widthText) / 2
             
             self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: 0, right: widthText + xImage)
             self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                 left: 30,
                                                 bottom: 0, right: 0)
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
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        rippleView.touchesCancelled(touches, with: event)
        super.touchesCancelled(touches, with: event)
        rippleView.isSelected = false
        rippleView.isRippleHighlighted = false
    }
}
