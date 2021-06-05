
import Foundation

protocol ParseTargetSupport {
    init?(str: String);
    static func get(num: NSNumber) -> Self;
    static func getDefault() -> Self;
}

func parseOpt<B: ParseTargetSupport>(_ val: Any?) -> B? {
    
    if let a = val {
        
        if !(a is NSNull) {
            
            if a is B {
                return a as? B;
            }
            
            if let aNum = a as? NSNumber {
                return B.get(num: aNum);
            }
            
            if let aStr = a as? String {
                
                return B(str: aStr);
            }
            
            print("Can't parse \(type(of: a))(\(a)) to \(B.self)")
        }
        
        return nil;
    }
    return nil;
    
}

func parse<B: ParseTargetSupport>(_ val: Any?) -> B {
    
    let b : B? = parseOpt(val);
    
    if let theB = b {
        return theB;
    }
    
    return B.getDefault();
}

extension Bool: ParseTargetSupport {
    
    static func get(num: NSNumber) -> Bool{
        return num.boolValue;
    }
    
    init?(str: String) {
        self.init(str);
    }
    
    static func getDefault() -> Bool {
        return false;
    }
}

extension Int: ParseTargetSupport {
    
    static func get(num: NSNumber) -> Int{
        return num.intValue;
    }
    
    init?(str: String) {
        self.init(str)
    }

    static func getDefault() -> Int {
        return 0;
    }
}

extension UInt: ParseTargetSupport {
    
    static func get(num: NSNumber) -> UInt{
        return num.uintValue;
    }
    
    init?(str: String) {
        self.init(str)
    }
    
    static func getDefault() -> UInt {
        return 0;
    }
}

extension Float: ParseTargetSupport {
    
    static func get(num: NSNumber) -> Float{
        return num.floatValue;
    }
    
    init?(str: String) {
        self.init(str)
    }
    
    static func getDefault() -> Float {
        return 0;
    }
}

extension Decimal: ParseTargetSupport {
    
    static func get(num: NSNumber) -> Decimal{
        return num.decimalValue;
    }
    
    init?(str: String) {
        self.init(string: str)
    }
    
    static func getDefault() -> Decimal {
        return Decimal(0);
    }
}

extension Double: ParseTargetSupport {
    
    static func get(num: NSNumber) -> Double{
        return num.doubleValue;
    }
    
    init?(str: String) {
        self.init(str)
    }
    
    static func getDefault() -> Double {
        return 0;
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func convertFromMeterToMiles() -> Double {
        let result = self / 1609.344
        return result.rounded(toPlaces: 2)
    }
    
}



extension String: ParseTargetSupport {
    
    static func get(num: NSNumber) -> String{
        return num.stringValue;
    }
    
    init?(str: String) {
        self.init(str);
    }
    
    static func getDefault() -> String {
        return "";
    }
}

extension Array where Element: ParseTargetSupport {
    
    init?(parsable object: Any?) {
        guard let array = object as? [Any] else{
            return nil;
        }
        
        self.init();
        for item in array {
            guard let parsedItem: Element = parseOpt(item) else{
                return nil;
            }
            append(parsedItem);
        }
    }
    
}

func parseDecimal(string: String?) -> Decimal? {
    guard let string = string else {
        return nil;
    }
    
    var amount: Decimal? = nil;
    
    var scannedAmount: Decimal = 0;
    let scanner = Scanner(string: string);
    
    while !scanner.isAtEnd {
        if scanner.scanDecimal(&scannedAmount){
            amount = scannedAmount;
            break;
        }
        
        scanner.scanLocation += 1;
    }
    
    return amount;
}

