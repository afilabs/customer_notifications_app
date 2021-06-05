//
//  ActionSheetPickerview.swift
//  RouteSimply
//
//  Created by Apple on 3/5/20.
//  Copyright © 2020 NguyenMV. All rights reserved.
//

import UIKit

class ActionSheetPickerview: UIViewController {
    
    public typealias Values = [[String]]
    public typealias Action = (_ vc: UIViewController, _ picker: UIPickerView, _ index: Index, _ values: Values) -> ()
    public typealias Index = (column: Int, row: Int)

    
    @IBOutlet weak var btnDone:UIButton?
    @IBOutlet weak var btnLeft1:UIButton?
    @IBOutlet weak var btnLeft2:UIButton?
    @IBOutlet weak var pickerView:UIPickerView?
    
    fileprivate var values: Values = [[]]
    fileprivate var initialSelection: Index?
    fileprivate var action: Action?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView?.dataSource = self
        pickerView?.delegate = self
        
        guard let row = initialSelection?.row,
            let column = initialSelection?.column  else {
            return
        }
        pickerView?.selectRow(row, inComponent: column, animated: true)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onbtnClickDone(btn:UIButton) {
        self.dismiss(animated: true, completion: {
            //
        })
    }
    
    @IBAction func onbtnClickLeft1(btn:UIButton) {
        guard let currentIndex = pickerView?.selectedRow(inComponent: 0),
            let _pickerView = pickerView,
            currentIndex > 0 else {
            return
        }
        pickerView?.selectRow(currentIndex - 1, inComponent: 0, animated: true)
        action?(self, _pickerView, Index(column: 0, row: currentIndex - 1), values)

    }
    
    @IBAction func onbtnClickLeft2(btn:UIButton) {
        guard let currentIndex = pickerView?.selectedRow(inComponent: 0),
            let _pickerView = pickerView  else {
               return
        }
        pickerView?.selectRow(currentIndex + 1, inComponent: 0, animated: true)
        action?(self, _pickerView, Index(column: 0, row: currentIndex + 1), values)
    }

}


// MARK: - HELPER FUNTIONS
extension ActionSheetPickerview{

    static func show(at vc:UIViewController,
              values: ActionSheetPickerview.Values,
              initialSelection: ActionSheetPickerview.Index? = nil,
              action: ActionSheetPickerview.Action? )  {
        let pickerview: ActionSheetPickerview = ActionSheetPickerview.load()
        pickerview.modalTransitionStyle = .coverVertical
        pickerview.modalPresentationStyle = .overFullScreen
        pickerview.initialSelection = initialSelection
        pickerview.values = values
        pickerview.action = action
        vc.present(pickerview, animated: true, completion: nil)
    }
    
}


// MARK: - UIPickerViewDataSource,UIPickerViewDelegate
extension ActionSheetPickerview: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values[component].count
    }
    
    /*
     // returns width of column and height of row for each component.
     public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
     
     }
     */
    
    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[component][row]
    }
    /*
     public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
     // attributed title is favored if both methods are implemented
     }
     
     
     public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
     
     }
     */
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        action?(self, pickerView, Index(column: component, row: row), values)
    }
}

