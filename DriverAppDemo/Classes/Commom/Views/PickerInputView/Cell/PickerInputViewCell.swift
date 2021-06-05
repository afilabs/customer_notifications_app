//
//  PickerInputViewCell.swift
//  VSip-iOS
//
//  Created by machnguyen_uit on 11/5/18.
//  Copyright © 2018 machnguyen_uit. All rights reserved.
//

import UIKit

protocol PickerInputViewCellDelegate:class {
    func pickerInputViewCell(cell :PickerInputViewCell, didSelectEdit btn:UIButton)
}

class PickerInputViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPlaceHolderText:UILabel?
    @IBOutlet weak var tvContent:UITextView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblSubtitle:UILabel?

    
    var oldText:String? = ""
    var placeHolderInputText:String? = ""
    weak var delegate:PickerInputViewCellDelegate?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTextView()
        setupLblPlaceHolderText()
    }
    
    func setupTextView()  {
        tvContent?.delegate = self
        //tvContent?.font = AppFont.applyWith(size: 15, fontType: .Regular)
        tvContent?.text = oldText
        lblPlaceHolderText?.isHidden = !isEmpty(oldText)

    }
    
    func setupLblPlaceHolderText()  {
        lblPlaceHolderText?.text = placeHolderInputText
        //lblPlaceHolderText?.font = AppFont.applyWith(size: 15, fontType: .Regular)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onbtnClickButtonaEdit(btn:UIButton){
        delegate?.pickerInputViewCell(cell: self, didSelectEdit: btn)
    }
}


//MARK: - UITextViewDelegate
extension PickerInputViewCell:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        //
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolderText?.isHidden = !isEmpty(textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //
    }
}
