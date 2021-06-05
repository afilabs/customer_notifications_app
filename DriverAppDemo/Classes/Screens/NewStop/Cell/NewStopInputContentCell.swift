//
//  NewStopInputContentCell.swift
//  RouteSimply
//
//  Created by Apple on 6/8/20.
//  Copyright © 2020 NguyenMV. All rights reserved.
//

import UIKit

class NewStopInputContentCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblContent:UILabel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configura(title:String?, content:String?,placeholder:String?)  {
        lblTitle?.text = title
        lblContent?.text = content
        if isEmpty(content){
            lblContent?.text = placeholder
            lblContent?.alpha = 0.3
        }else {
            lblContent?.alpha = 1
        }        
    }

}
