//
//  NewStopInputCell.swift
//  RouteSimply
//
//  Created by Apple on 12/28/19.
//  Copyright © 2019 NguyenMV. All rights reserved.
//

import UIKit
import PhoneNumberKit


protocol NewStopInputCellDelegate:AnyObject {
    func newStopInputCell(cell:NewStopInputCell, onChangeText text:String)
    func newStopInputCell(cell:NewStopInputCell, textFieldDidBeginEditing textField:UITextField)

}

class NewStopInputCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var tfContent:UITextField?
    @IBOutlet weak var lblContent:UILabel?

    weak var delegate:NewStopInputCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configura(title:String?, content:String?,placeholder:String?,keyboardType:UIKeyboardType = .default)  {
        lblTitle?.text = title
        tfContent?.text = content
        tfContent?.placeholder = placeholder
        tfContent?.delegate = self
        lblContent?.text = content
        lblContent?.text = content
        tfContent?.keyboardType  = keyboardType
        if isEmpty(content){
            lblContent?.text = placeholder
            lblContent?.alpha = 0.3
        }else {
            lblContent?.alpha = 1
        }        
    }
}


//MARK: -UITextFieldDelegate
extension NewStopInputCell:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.newStopInputCell(cell: self, textFieldDidBeginEditing: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            delegate?.newStopInputCell(cell: self, onChangeText: updatedText)
        }
        
        return  true
    }
}
