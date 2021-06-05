
import Foundation

protocol ValidateUtils_ {
 
    static func validateEmail(_ email: String) -> Bool
    static func validatePassword(_ pass: String) -> Bool
}


class ValidateUtils : ValidateUtils_ {
    
    
    static func validateEmail(_ email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%'+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        return predicate.evaluate(with: email);
    }
    
    static func validatePassword(_ pass: String) -> Bool{
        if isEmpty(pass) {
            return false
        }
        
        let passRegEx = "(?=^.{6,}$)((?=.*\\d)(?=.*\\W+)|(?=.*_))(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passRegEx);
        return predicate.evaluate(with: pass);
    }
    
}
