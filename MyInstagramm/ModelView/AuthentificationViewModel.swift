import UIKit


class LoginViewModel {
    
    
    var email: String
    var password: String
    
    var isValidate: Bool {
        return email.count > 3 && password.count > 3
    }
    
    
    var colorButton: UIColor {
        return isValidate ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.9486505389, green: 0.4501413703, blue: 1, alpha: 1).withAlphaComponent(0.2)
    }
    
    
    var buttonTitleColor: UIColor {
        return isValidate ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(white: 1, alpha: 0.67)
    }
    
    init(){
        self.email = ""
        self.password = ""
    }
}



class RegistrationViewModel {
    
    
    var email: String = ""
    var password: String = ""
    var fullname: String = ""
    var username: String = ""
    var imageHave: Bool = false
    
    var isValidate: Bool {
        return email.count > 2 && password.count > 2 && fullname.count > 2 && username.count > 2 && imageHave
    }
    
    
    var colorButton: UIColor {
        return isValidate ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.9486505389, green: 0.4501413703, blue: 1, alpha: 1).withAlphaComponent(0.2)
    }
    
    
    var buttonTitleColor: UIColor {
        return isValidate ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(white: 1, alpha: 0.67)
    }
    

}
