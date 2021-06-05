//
//  PickerHourCell.swift
//  CiroDoor
//
//  Created by Apple on 3/21/20.
//  Copyright © 2020 machnguyen_uit. All rights reserved.
//

import UIKit

protocol PickerHourCellDelegate:AnyObject {
    func pickerHourCell(cell:PickerHourCell, didSelectRow value:(from:Int,to:Int))

}

class PickerHourCell: UITableViewCell {
    
    @IBOutlet weak var fromPicker:UIPickerView!
    @IBOutlet weak var toPicker:UIPickerView!
    
    var values:[String] = []
    
    var initialValue:(from:Int,to:Int)?
    
    weak var delegate:PickerHourCellDelegate?
    


    override func awakeFromNib() {
        super.awakeFromNib()
        setupData()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectRow()
    }
    
    @objc func selectRow()  {
        if let _oldData = initialValue {
           let indexFrom = values.index(of: "\(_oldData.from)") ?? 0
           let indexTo = values.index(of: "\(_oldData.to)") ?? 0
           fromPicker.selectRow(indexFrom , inComponent: 0, animated: true)
           toPicker.selectRow(indexTo, inComponent: 0, animated: true)
       }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupData() {
        values  = []
        var start = 0
        let end = 24

        while start < end {
          start = start + 1
          values.append("\(start)")
        }
    }
    
    func setupUI() {
        fromPicker.delegate = self
        fromPicker.dataSource = self
        toPicker.delegate = self
        toPicker.dataSource = self
        fromPicker.tag = 1
        toPicker.tag = 2
    }
    
    func configura(oldData:(from:Int,to:Int)? = nil)  {
        initialValue = oldData
    }
}


// MARK: - UIPickerViewDataSource,UIPickerViewDelegate
extension PickerHourCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    /*
     // returns width of column and height of row for each component.
     public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
     
     }
     */
    
    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }
    
    /*
     public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
     // attributed title is favored if both methods are implemented
     }
     
     
     public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
     
     }
     */
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let fromIndex = fromPicker.selectedRow(inComponent: 0)
        let toIndex = toPicker.selectedRow(inComponent: 0)
        delegate?.pickerHourCell(cell: self,
                                 didSelectRow: (Int(values[fromIndex]) ?? 1,Int(values[toIndex]) ?? 1))

        if pickerView.tag == 1 {
            print("==>From:\(values[row])")
        }else {
            print("==>To:\(values[row])")
        }
    }
    
}

