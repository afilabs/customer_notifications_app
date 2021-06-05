
import UIKit;

extension UISearchBar {
    
    func findSearchTextField() -> UITextField? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return nil }
        
        return tf

        /*
        var foundTf : UITextField? = nil;
    
        let viewsOrNil = CommonUtils.OSVersion() < 7.0 ? subviews : self.subviews.first?.subviews;
        
        if let views = viewsOrNil {
            
            for subview in views {
                
                if let tf = subview as? UITextField {
                    foundTf = tf;
                }
                
            }
            
        }
        
        return foundTf;
         */
    }
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
