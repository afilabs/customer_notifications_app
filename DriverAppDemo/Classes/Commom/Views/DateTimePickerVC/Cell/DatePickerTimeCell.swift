//
//  DatePickerTimeCell.swift
//  CiroDoor
//
//  Created by machnguyen_uit on 8/18/18.
//  Copyright © 2018 machnguyen_uit. All rights reserved.
//

import UIKit

class DatePickerTimeCell: UITableViewCell {
    
    @IBOutlet weak var fromDatePicker:UIDatePicker?
    @IBOutlet weak var toDatePicker:UIDatePicker?

    override func awakeFromNib() {
        super.awakeFromNib()
          fromDatePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
          toDatePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
          fromDatePicker?.addTarget(self,
                                    action: #selector(datePickerChanged(picker:)),
                                    for: .valueChanged)
          toDatePicker?.addTarget(self,
                                  action: #selector(datePickerChanged(picker:)),
                                  for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func datePickerChanged(picker: UIDatePicker){
        print("Date Change:\(picker.date)")
        if fromDatePicker?.date > toDatePicker?.date {
            fromDatePicker?.maximumDate = toDatePicker?.date
        }
    }
}
