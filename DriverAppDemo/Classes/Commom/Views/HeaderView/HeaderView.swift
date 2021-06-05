//
//  HeaderView.swift
//  RouteSimply
//
//  Created by Apple on 12/22/19.
//  Copyright © 2019 NguyenMV. All rights reserved.
//

import UIKit


protocol HeaderViewDelegate:AnyObject {
    func headerView(view:HeaderView, didSelectLeftButton btn:UIButton);
    func headerView(view:HeaderView, didSelectRightButton btn:UIButton);
    func headerView(view:HeaderView, didSelectDropdownButton btn:UIButton);
    func headerView(view:HeaderView, didSelectRightButtonText btn:UIButton);
}

extension HeaderViewDelegate {
    func headerView(view:HeaderView, didSelectLeftButton btn:UIButton){}
    func headerView(view:HeaderView, didSelectRightButton btn:UIButton){}
    func headerView(view:HeaderView, didSelectDropdownButton btn:UIButton){}
    func headerView(view:HeaderView, didSelectRightButtonText btn:UIButton){}
}

enum HeaderViewType {
    case custom
    case home
    case backOnly
    case dropdownAdd
    case titleOnly
    case titleAdd
    case backAdd
    case rightButtonText(_ name:String)
}

class HeaderView: UIView {
    
    @IBOutlet weak var lblLargeTitle:UILabel?
    @IBOutlet weak var lblSmallTitle:UILabel?
    @IBOutlet weak var btnLeft:UIButton?
    @IBOutlet weak var btnRight:UIButton?
    @IBOutlet weak var btnDropdown:UIButton?
    @IBOutlet weak var btnRightButtonText:UIButton?
    @IBOutlet weak var btnRightTwo:UIButton?

    
    weak var delegate:HeaderViewDelegate?
    
    private lazy var iconBack = UIImage(named: "ic_back_blue")
    private lazy var iconDropdown = UIImage(named: "ic_dropdown")
    private lazy var iconAdd = UIImage(named: "ic_add_blue")


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

    private func setupView()  {
       let bundle = Bundle(for: HeaderView.self)
       if let view = UINib(nibName: "HeaderView", bundle: bundle).instantiate(withOwner: self, options: nil).first as? UIView {
           view.frame = bounds
           view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           view.translatesAutoresizingMaskIntoConstraints = true
           addSubview(view)
       }
    }
    
    
    func setHeaderView(type:HeaderViewType = .custom,
                       title: String = "",
                       disableRightButton:Bool = false) {
        hidenAll()
        switch type {
        case .custom:
         break
            
        case .backOnly:
            lblSmallTitle?.isHidden = false
            btnLeft?.isHidden = false
            lblSmallTitle?.text = title
            btnLeft?.image = iconBack
            
        case .home:
            lblLargeTitle?.isHidden = false
            btnRight?.isHidden = false
            btnRightTwo?.isHidden = false
            lblLargeTitle?.text = title
            btnRight?.image = iconAdd
            btnRightTwo?.title = "Add Stop"
            btnRightTwo?.titleColor = AppColor.primary

        case .titleOnly:
            lblSmallTitle?.isHidden = false
            lblSmallTitle?.text = title
            
        case .dropdownAdd:
            lblSmallTitle?.isHidden = false
            btnRight?.isHidden = false
            btnDropdown?.isHidden = false
            lblSmallTitle?.text = title
            btnRight?.image = iconAdd
            btnDropdown?.image = iconDropdown
            
        case .titleAdd:
            lblSmallTitle?.isHidden = false
            btnRight?.isHidden = false
            lblSmallTitle?.text = title
            btnRight?.image = iconAdd
            btnRight?.isEnabled = !disableRightButton
            btnRight?.alpha = disableRightButton ? 0.5 : 1
            
        case .backAdd:
            lblSmallTitle?.isHidden = false
            btnLeft?.isHidden = false
            lblSmallTitle?.text = title
            btnRight?.isHidden = false
            btnLeft?.image = iconBack
            btnRight?.image = iconAdd
            
        case .rightButtonText(let name):
             lblSmallTitle?.isHidden = false
             btnLeft?.isHidden = false
             lblSmallTitle?.text = title
             btnRightButtonText?.isHidden = false
             btnLeft?.image = iconBack
             btnRightButtonText?.title = name
        }
    }
    
    func hidenAll()  {
        lblLargeTitle?.isHidden = true
        lblSmallTitle?.isHidden = true
        btnLeft?.isHidden = true
        btnRight?.isHidden = true
        btnDropdown?.isHidden = true
        btnRightButtonText?.isHidden = true
        btnRightTwo?.isHidden = true
    }
    
    @IBAction func onbtnClickButtonLeft(btn:UIButton){
        delegate?.headerView(view: self, didSelectLeftButton: btn)
        
    }
    
    @IBAction func onbtnClickButtonRight(btn:UIButton){
        delegate?.headerView(view: self, didSelectRightButton: btn)
    }
    
    @IBAction func onbtnClickButtonDropdown(btn:UIButton){
        delegate?.headerView(view: self, didSelectDropdownButton: btn)
     }
    
    @IBAction func onbtnClickRightButtonText(btn:UIButton){
        delegate?.headerView(view: self, didSelectRightButtonText: btn)
     }
    
}
