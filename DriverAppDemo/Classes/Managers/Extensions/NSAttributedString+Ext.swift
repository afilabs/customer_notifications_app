

import UIKit

extension NSAttributedString {
    
    convenience init(string: String, color: UIColor? = nil, backgroundColor: UIColor? = nil, font: UIFont? = nil, kern: Double? = nil) {
        var attributes: [NSAttributedString.Key: Any] = [:];
        if let theColor = color { attributes[NSAttributedString.Key.foregroundColor] = theColor }
        if let theColor = backgroundColor { attributes[NSAttributedString.Key.backgroundColor] = theColor }
        if let theFont = font { attributes[NSAttributedString.Key.font] = theFont }
        if let theKern = kern { attributes[NSAttributedString.Key.kern] = NSNumber(value: theKern) }
        
        self.init(string: string, attributes: attributes)
    }
    
}
