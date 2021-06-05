
import Foundation
import UIKit

func TRIM(val: String?) -> String? {
    return val?.trimmingCharacters(in: .whitespaces);
}

extension String {
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    var length: Int{
        get { return count }
    }
    
    var isNotEmpty: Bool {
        get { return !isEmpty }
    }
    
    static func random(length: Int = 20) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            let index = base.index(base.startIndex, offsetBy: Int(randomValue))
            randomString += "\(base[index])"
        }
        
        return randomString
    }
    
    var localized: String {
        //return LanguageHelper.getValue(forKey: self)
        
        return NSLocalizedString(self,
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "", comment: "")
         
        
    }
    
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
    
    var integerValue: Int {
        return Int(self) ?? 0
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    // MARK: URL
    
    func encodeURL(allowedCharacters: CharacterSet = .urlQueryAllowed) -> String? {
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters);
    }
    
    func encodeURLForMap(allowedCharacters: CharacterSet = .urlQueryAllowed) -> String? {
        let plusAppliedString = replacingOccurrences(of: " ", with: "+", options: .literal, range: nil);
        return plusAppliedString.encodeURL(allowedCharacters: allowedCharacters);
    }
    
    func decodeURL() -> String? {
        return removingPercentEncoding;
    }
    
    // MARK: Others
    
    func trim(characters : CharacterSet = .whitespaces) -> String {
        return trimmingCharacters(in:characters);
    }
    
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return self[fromIndex...].toString()//substring(from: fromIndex)
    }   
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return self[..<toIndex].toString()//substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return self[startIndex..<endIndex].toString();
    }
    
    func getWidth(font: UIFont) -> CGFloat{
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func getHeight(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        
        return label.frame.height
    }
    
    static func name(first: String?, last: String?) -> String {
        return "\(first?.capitalized ?? "") \(last?.capitalized ?? "")";
    }
    
    // MARK: example
    private func example(){
        
        
        let str = "abc...xyz";
        
        _ = str.encodeURL();
        _ = str.decodeURL();
        
        _ = str.trim();
        
        
    }
}

//MARK: - HTML

extension String {
    /// Returns an html decoded string, if any part of the decoding fails it returns itself
    func htmlDecodedStringOrSelf() -> String {
        guard contains("&"), contains(";"), let htmlData = data(using: .utf8, allowLossyConversion: false) else {
            return self
        }
        
        do {
            let attributedString =
                try NSAttributedString(data: htmlData,
                                       options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                 NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                                       documentAttributes: nil)
            return attributedString.string
        } catch {
            return self
        }
    }
    
    func htmlAttributedString(fontSize: CGFloat = 17.0) -> NSAttributedString? {
        let fontName = UIFont.systemFont(ofSize: fontSize).fontName
        let string = self.appending(String(format: "<style>body{font-family: '%@'; font-size:%fpx;}</style>", fontName, fontSize))
        guard let data = string.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }

        guard let html = try? NSMutableAttributedString (
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }
    
}

//MARK: - Substring

extension Substring {
    
    func toString() -> String{
        return String(self);
    }
}

// CALL
extension String {

    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }

    func isValid(regex: RegularExpressions) -> Bool { return isValid(regex: regex.rawValue) }
    func isValid(regex: String) -> Bool { return range(of: regex, options: .regularExpression) != nil }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

    func makeCall() {
        let phone = self.replacingOccurrences(of: " ", with: "")
        guard  isValid(regex: .phone),
                let url = URL(string: "tel://\(phone)"),
                UIApplication.shared.canOpenURL(url) else {
                //App().showAlert("Error", "Can't make the call with this phone number.")
                return
        }
        
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    

    func toDate(withFormat format: String = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ")-> Date?{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = format
          dateFormatter.timeZone = TimeZone(identifier: "UTC")
          let date = dateFormatter.date(from: self)

          return date
    }
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }

    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
