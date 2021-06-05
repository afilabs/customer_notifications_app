
import Foundation

//MARK: - DateFormatter
extension DateFormatter {
    
    convenience init(format: String, timeZone: TimeZone) {
        self.init();
        
        self.locale = .en_US_POSIX;
        self.dateFormat = format;
        self.timeZone = timeZone;
    }
    
    convenience init(format: String) {
        self.init(format: format, timeZone: TimeZone.current);
    }
}


let ServerDateFormater = DateFormatter.serverDateFormater
let DateUSFormater = DateFormatter.displayDateShortText
let TimeFormater = DateFormatter.displayTime
let EventFormater = DateFormatter.displayDateForEvent


//MARK: - DateFormatter Instance
extension DateFormatter {
    static let displayDateForEvent = DateFormatter(format: "EEEE', 'MMMM' 'dd'");

    static let displayDateForOrder = DateFormatter(format: "EEE', 'MMM' 'dd', 'yyyy");
    static let displayDateFull = DateFormatter(format: "dd/MM/yyyy");
    static let serverDateFormater = DateFormatter(format: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'", timeZone: TimeZone(identifier: "UTC")!);
    static let displayDateShortText = DateFormatter(format: "dd MMM yyyy")
    static let displayFullDateTime = DateFormatter(format: "d MMM yyyy HH:mm")
    static let displayCreator = DateFormatter(format: "d-M-yyyy")
    static let displayTime = DateFormatter(format: "HH:mm")
    
}
