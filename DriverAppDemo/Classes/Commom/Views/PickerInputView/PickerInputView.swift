//
//  PickerInputView.swift
//  DMS
//
//  Created by machnguyen_uit on 11/5/18.
//  Copyright © 2018 machnguyen_uit. All rights reserved.
//

import UIKit

enum PickerInputViewType:Int {
    case PickerInputTextView = 0
    case PickerInputTextViewAndAttachment = 1
}

typealias PickerInputViewCallback = (_ success:Bool, _ text:String, _ files:[AttachFileModel]?) -> Void

class PickerInputView: BaseVC {
    
    enum SectionPickerInputView :Int{
        case TextView = 0
        case Attachment = 1
    }
    
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblSubTitle:UILabel?
    @IBOutlet weak var tbvContent:UITableView?
    @IBOutlet weak var btnCancel:UIButton?
    @IBOutlet weak var btnDone:UIButton?
    @IBOutlet weak var vContent:UIView?
    @IBOutlet weak var conHeightViewContent:NSLayoutConstraint?
    
    fileprivate let identifierTvcell = "PickerInputTVCell"
    fileprivate let identifierHeadercell = "PickerInputViewHeaderCell"
    fileprivate let identifierAttachmentcell = "PickerInputViewAttachmentCell"

    var placeHolderInputText:String?
    var titleText:String? = "Picker Input"
    var subTitleText = ""
    var titleHeaderAttach:String? = "Attachments"
    var oldText:String?

    var type:PickerInputViewType = .PickerInputTextView
    var callback:PickerInputViewCallback?
    var tvContent:UITextView?
    var attachmentList:[AttachFileModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        oldText = tvContent?.text
    }
    
    func setupTableView()  {
        tbvContent?.delegate = self
        tbvContent?.dataSource = self
    }
    
    func updateUI() {
        DispatchQueue.main.async {[weak self] in
            //lblTitle?.font = AppFont.applyWith(size: 17, fontType: .Regular)
            self?.lblTitle?.text = self?.titleText
            self?.lblSubTitle?.text = self?.subTitleText
            
            switch (self?.type)! {
            case .PickerInputTextView:
                self?.conHeightViewContent?.constant = isEmpty(self?.subTitleText) ? 220 : 250
                
            case .PickerInputTextViewAndAttachment:
                self?.conHeightViewContent?.constant = CGFloat(260 + ((self?.attachmentList.count ?? 0) * 50))
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - ACTION
    @IBAction func onbtnClickDone(btn:UIButton) {
        if isEmpty(self.tvContent?.text) {
            showAlertView("Content cann't empty.".localized)
            return
        }
        
        self.dismiss(animated: false) {
            self.callback?(true,E(self.tvContent?.text),self.attachmentList)
        }
    }

    @IBAction func onbtnClickCancel(btn:UIButton){
        self.dismiss(animated: false, completion: nil)
    }

}


//MARK: - UITableViewDataSource
extension PickerInputView:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch type {
        case .PickerInputTextView:
            return 1
        case .PickerInputTextViewAndAttachment:
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch type {
        case .PickerInputTextView:
            return 1
            
        case .PickerInputTextViewAndAttachment:
            if let _section = SectionPickerInputView(rawValue: section){
                switch _section{
                case .Attachment:
                    return  attachmentList.count
                    
                case .TextView:
                    return 1
                }
            }
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch type {
        case .PickerInputTextView:
            return nil
            
        case .PickerInputTextViewAndAttachment:
            if section == SectionPickerInputView.TextView.rawValue{
                return nil
            }
            let header = tableView.dequeueReusableCell(withIdentifier: identifierHeadercell) as! PickerInputViewCell
            header.lblTitle?.text = titleHeaderAttach
            //header.lblTitle?.font = AppFont.applyWith(size: 15, fontType: .Regular)
            header.lblTitle?.alpha = 0.5
            header.delegate = self
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch type {
        case .PickerInputTextView:
            return 0
        case .PickerInputTextViewAndAttachment:
            if section == SectionPickerInputView.TextView.rawValue{
                return 0
            }
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:PickerInputViewCell?
        
        switch type {
        case .PickerInputTextView:
            cell = tableView.dequeueReusableCell(withIdentifier: identifierTvcell, for: indexPath) as? PickerInputViewCell
            cell?.placeHolderInputText = placeHolderInputText
            cell?.oldText = oldText
            tvContent = cell?.tvContent
            
        case .PickerInputTextViewAndAttachment:
            
            if let section = SectionPickerInputView(rawValue: indexPath.section){
                
                switch section{
                case .TextView:
                    cell = tableView.dequeueReusableCell(withIdentifier: identifierTvcell, for:indexPath) as? PickerInputViewCell
                    cell?.placeHolderInputText = placeHolderInputText
                    tvContent = cell?.tvContent
                    cell?.oldText = oldText

                case .Attachment:
                    let file = attachmentList[indexPath.row]
                    cell = tableView.dequeueReusableCell(withIdentifier: identifierAttachmentcell, for: indexPath) as? PickerInputViewCell
                    cell?.lblTitle?.text =  file.name
                    //cell?.lblSubtitle?.text = Caches().user?.userInfo?.userName
                    //cell?.lblSubtitle1?.text = DateUSFormater.string(from: Date.now)
                }
            }
        }
        
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
}

extension PickerInputView:PickerInputViewCellDelegate{
    func pickerInputViewCell(cell: PickerInputViewCell, didSelectEdit btn: UIButton) {
        /*
        let vc:AddAttachmentVC = AddAttachmentVC.load(SB: .Common)
        
        vc.setCallback {[weak self] (success, data) in
            self?.attachmentList.append(data)
            self?.updateUI()
            self?.tbvContent?.reloadData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
         */
    }
}


//MARK: - UITableViewDelegate
extension PickerInputView:UITableViewDelegate{
    
    
}


//MARK: - FUNTION SUPPORT
extension PickerInputView{
    
    class func showInputViewWith(type :PickerInputViewType,
                           atVC:UIViewController,
                           title:String? = nil,
                           subTitle:String? = nil,
                           titleAttach:String? = nil,
                           currentText:String? = nil,
                           placeHolder:String? = nil,
                           _callback:@escaping PickerInputViewCallback)  {
        
        let vc:PickerInputView = PickerInputView.load(SB: .Commons)
        vc.setCallback(_callback)
        vc.type = type
        vc.titleText = title
        vc.subTitleText = E(subTitle)
        vc.placeHolderInputText = placeHolder
        vc.titleHeaderAttach = titleAttach
        vc.oldText = currentText
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5);
        atVC.present(vc, animated: true, completion: nil)
    }
    
    func setCallback(_ _callback:@escaping PickerInputViewCallback) {
        self.callback = _callback
    }
}
