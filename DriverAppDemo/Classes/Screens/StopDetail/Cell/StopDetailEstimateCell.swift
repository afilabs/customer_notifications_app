
import UIKit

protocol StopDetailEstimateCellDelegate:AnyObject {
    func stopDetailEstimateCell(cell:StopDetailEstimateCell, didSelectEdit btn:UIButton)
}

class StopDetailEstimateCell: UITableViewCell {
    
    @IBOutlet weak var vContent:UIView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblStatus:UILabel?
    @IBOutlet weak var lblSubTitle:UILabel?
    @IBOutlet weak var lblPhone:UILabel?
    @IBOutlet weak var lblTime:UILabel?
    @IBOutlet weak var vStatus:UIView?
    @IBOutlet weak var vPhoneNumber:UIView?
    @IBOutlet weak var vETA:UIView?
    @IBOutlet weak var imv:UIImageView?
    @IBOutlet weak var imvETA:UIImageView?
    
    
    weak var delegate:StopDetailEstimateCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onbtnClickEdit(btn:UIButton){
        UIView.animate(withDuration: 0.1, animations: {
            btn.titleColor = AppColor.primary.withAlphaComponent(0.5)

        }) { (finished) in
            btn.titleColor = AppColor.primary
            self.delegate?.stopDetailEstimateCell(cell: self, didSelectEdit: btn)
        }
    }
    
    
    func configure(delegate:StopDetailEstimateCellDelegate, order:OrderModel?) {
        self.delegate = delegate
        let isShowStatus = (order?.status == .completed || order?.status == .failed)
        let address = (order?.address1 ?? "") + " " + (order?.address2 ?? "")
        vStatus?.cornerRadius = 5
        vStatus?.isHidden = !(isShowStatus)
        vETA?.isHidden = isShowStatus
        vStatus?.backgroundColor = order?.colorStatus
        lblTitle?.text = order?.name
        lblSubTitle?.text = address
        lblPhone?.text =  "Deliver by  \(order?.deliverBy ?? "")"
        vPhoneNumber?.isHidden = isEmpty(order?.deliverBy)
        lblTime?.text = order?.eta
        lblStatus?.text = order?.status.name
        lblStatus?.textColor = .white
        imvETA?.image = #imageLiteral(resourceName: "ic_estimate")
    }

}
