//
//  PhoneNumberCell.swift
//  RouteSimply
//
//  Created by Apple on 1/31/20.
//  Copyright © 2020 NguyenMV. All rights reserved.
//

import UIKit
import PhoneNumberKit


protocol PhoneNumberCellDelegate:AnyObject {
    func phoneNumberCell(cell:PhoneNumberCell, onChangeText text:String)
    func phoneNumberCell(cell:PhoneNumberCell, textFieldDidBeginEditing textField:UITextField)

}

class PhoneNumberCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var tfPhoneNumber:PhoneNumberTextField?
    
    weak var delegate:PhoneNumberCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPhoneNumberTextField(phone:String? = nil) {
        let phoneNumberKit = PhoneNumberKit()
        let phoneNumber = try? phoneNumberKit.parse(phone ?? "")
        let countryCode = phoneNumber?.countryCode
        PhoneNumberKit.CountryCodePicker.forceModalPresentation = true
        tfPhoneNumber?.text = phone
        tfPhoneNumber?.withFlag = true
        tfPhoneNumber?.withExamplePlaceholder = true
        tfPhoneNumber?.withDefaultPickerUI = true
        tfPhoneNumber?.isPartialFormatterEnabled = true
        tfPhoneNumber?.delegate = self
        
        if let _countryCode = countryCode,
          let defaultRegion = phoneNumberKit.mainCountry(forCode: _countryCode) {
            tfPhoneNumber?.defaultRegion = defaultRegion
        }
    }
    
    func configura(title:String?, content:String?,placeholder:String?)  {
        lblTitle?.text = title
        setupPhoneNumberTextField(phone: content)
    }
}


//MARK: -UITextFieldDelegate
extension PhoneNumberCell:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.phoneNumberCell(cell: self, textFieldDidBeginEditing: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            delegate?.phoneNumberCell(cell: self, onChangeText: updatedText)
        }
        
        return  true
    }
}

