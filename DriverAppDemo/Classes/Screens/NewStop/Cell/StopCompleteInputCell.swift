//
//  StopCompleteInputCell.swift
//  RouteSimply
//
//  Created by Apple on 3/17/20.
//  Copyright © 2020 NguyenMV. All rights reserved.
//

import UIKit

protocol StopCompleteInputCellDelegate:AnyObject {
    func stopCompleteInputCell(cell:StopCompleteInputCell, didChangeInputText text:String)
}

class StopCompleteInputCell: UITableViewCell {
    @IBOutlet weak var vContent:UIView?
    @IBOutlet weak var tvContent:UITextView?
    @IBOutlet weak var lblPlaceHolder:UILabel?

    
    weak var delegate:StopCompleteInputCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI()  {
        selectionStyle = .none
        vContent?.cornerRadius = 8
        vContent?.borderColor = UIColor(hex: "F2F2F2")
        vContent?.borderWidth = 1
        tvContent?.delegate = self
    }
    
    func configura(delegate:StopCompleteInputCellDelegate,
                   text:String,
                   placeholder:String? = nil)  {
        self.delegate = delegate
        tvContent?.text = text
        lblPlaceHolder?.isHidden = !isEmpty(text)
        if !isEmpty(placeholder) {
            lblPlaceHolder?.text = placeholder
        }
    }

}

//MARK: - UITextViewDelegate
extension StopCompleteInputCell:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolder?.isHidden = !isEmpty(textView.text)
        delegate?.stopCompleteInputCell(cell: self, didChangeInputText: textView.text)
    }
}
