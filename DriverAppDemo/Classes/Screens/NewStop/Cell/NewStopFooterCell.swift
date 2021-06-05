//
//  NewStopFooterCell.swift
//  RouteSimply
//
//  Created by Apple on 12/28/19.
//  Copyright © 2019 NguyenMV. All rights reserved.
//

import UIKit


protocol NewStopFooterCellDelegate:AnyObject {
    func newStopFooterCell(cell:NewStopFooterCell, didSelectAdd btn:UIButton)
    func newStopFooterCell(cell:NewStopFooterCell, didSelectAdditionalInput btn:UIButton)

}

class NewStopFooterCell: UITableViewCell {
    
    @IBOutlet weak var btnAdd:BlueButton?
    @IBOutlet weak var lblAdditional:UIButton!
    @IBOutlet weak var imvAdditional:UIImageView?

    weak var delegate:NewStopFooterCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    @IBAction func onbtnClickAdd(btn:UIButton){
        delegate?.newStopFooterCell(cell: self, didSelectAdd: btn)
    }
    
    @IBAction func onbtnClickAdditionalInput(btn:UIButton){
        lblAdditional.isSelected = !lblAdditional!.isSelected
        lblAdditional.setTitle(lblAdditional.isSelected ? "Less" : "Additional Input", for: .normal)
        imvAdditional?.image =  lblAdditional.isSelected ? #imageLiteral(resourceName: "ic_arrow_up") : #imageLiteral(resourceName: "ic_arrow_down")
        delegate?.newStopFooterCell(cell: self, didSelectAdditionalInput: btn)
    }
    
    func configura(titleAddButton:String, enableButtonAdd:Bool, showAdditional:Bool) {
        //imvAdditional?.image =  showAdditional ? #imageLiteral(resourceName: "ic_arrow_up") : #imageLiteral(resourceName: "ic_arrow_down")
        btnAdd?.title = titleAddButton
        btnAdd?.isEnabled = enableButtonAdd
        btnAdd?.alpha = enableButtonAdd ? 1 : 0.6
    }

}
