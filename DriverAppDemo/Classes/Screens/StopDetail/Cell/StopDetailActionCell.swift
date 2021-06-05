
import UIKit
import MaterialComponents.MaterialRipple


protocol StopDetailActionCellDelegate:AnyObject {
    func stopDetailActionCell(cell:StopDetailActionCell,didSelectGoingNext btn:UIButton?)
    func stopDetailActionCell(cell:StopDetailActionCell,didSelectNavigate btn:UIButton?)
    func stopDetailActionCell(cell:StopDetailActionCell,didSelectCall btn:UIButton?)

}

class StopDetailActionCell: UITableViewCell {
    
    @IBOutlet weak var vGoingNext:ButtonIconOverText?
    @IBOutlet weak var vNavigate:ButtonIconOverText?
    @IBOutlet weak var vCall:ButtonIconOverText?
    
    let rippleView = MDCRippleView()
    
    
    
    weak var delegate:StopDetailActionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI()  {
        vGoingNext?.cornerRadius = 8
        vNavigate?.cornerRadius = 8
        vCall?.cornerRadius = 8
        vGoingNext?.borderWidth = 1
        vGoingNext?.borderColor = AppColor.goingNext
        vGoingNext?.backgroundColor = AppColor.goingNext.withAlphaComponent(0.2)
        vGoingNext?.icon = #imageLiteral(resourceName: "ic_going_next")
        vGoingNext?.title = "Send ETA"
        vGoingNext?.titleColor = AppColor.goingNext
        vGoingNext?.onPress = {[unowned self] (btn) in
              self.delegate?.stopDetailActionCell(cell: self, didSelectGoingNext: btn)
        }
        vNavigate?.borderWidth = 1
        vNavigate?.borderColor = AppColor.navigate
        vNavigate?.backgroundColor = AppColor.navigate.withAlphaComponent(0.2)
        vNavigate?.icon = #imageLiteral(resourceName: "ic_navigate_up_arrow")
        vNavigate?.title = "Navigate"
        vNavigate?.titleColor = AppColor.navigate
        vNavigate?.onPress = {[unowned self] (btn) in
            self.delegate?.stopDetailActionCell(cell: self, didSelectNavigate: btn)
        }
        vCall?.borderWidth = 1
        vCall?.borderColor = AppColor.call
        vCall?.backgroundColor = AppColor.call.withAlphaComponent(0.2)
        vCall?.icon = #imageLiteral(resourceName: "ic_call_green")
        vCall?.title = "Call"
        vCall?.titleColor = AppColor.call
        vCall?.onPress = {[unowned self] (button) in
            self.delegate?.stopDetailActionCell(cell: self, didSelectCall: button)
        }
    }
    
    func configura(order:OrderModel?)  {
        vGoingNext?.isUserInteractionEnabled = order?.canGoingNext ?? false
        vGoingNext?.alpha = (order?.canGoingNext ?? false) ? 1 : 0.3
    }
}
