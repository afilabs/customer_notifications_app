//
//  UITableView+Ext.swift
//  VSip-iOS
//
//  Created by machnguyen_uit on 8/4/18.
//  Copyright © 2018 machnguyen_uit. All rights reserved.
//

import Foundation
import UIKit

 extension UITableView {
    func registerCellClass <CellClass: UITableViewCell> (cellClass: CellClass.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.description())
    }
    
    func registerCellNibForClass(cellClass: AnyClass) {
        let classNameWithoutModule = cellClass
            .description()
            .components(separatedBy: ".")
            .dropFirst()
            .joined(separator: ".")
        
        register(UINib(nibName: classNameWithoutModule, bundle: nil),
                 forCellReuseIdentifier: classNameWithoutModule)
    }
    
    func addRefreshControl(_ target: Any?, action: Selector) {
        let refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh".localized)
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    public  func isRefreshing() -> Bool {
        return self.refreshControl?.isRefreshing ?? false
    }
    
    public  func endRefreshControl() {
        self.refreshControl?.endRefreshing()
    }
}

