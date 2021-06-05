//
//  MainVC.swift
//  DriverAppDemo
//
//  Created by Apple on 4/1/21.
//

import UIKit

class MainVC: UIViewController {

    var rootNV:UINavigationController?
    var stopVC:StopDetailVC?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc:StopDetailVC = StopDetailVC.load(SB: SBName.Stop)
        stopVC = vc
        rootNV?.viewControllers = [vc]
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Root_NV" {
            rootNV = segue.destination as? UINavigationController
        }
    }
    
}

