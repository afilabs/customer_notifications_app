//
//  NewStopHeaderCell.swift
//  RouteSimply
//
//  Created by Apple on 12/28/19.
//  Copyright © 2019 NguyenMV. All rights reserved.
//

import UIKit

class NewStopHeaderCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configura(title:String?)  {
        lblTitle?.text = title
    }
}
