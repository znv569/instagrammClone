import Foundation
import Firebase

struct RegisterCredentials {
    let email: String
    let password: String
    let username: String
    let fullname: String
    let imageProfile: UIImage
}



class AuthService{
    
    static let shared = AuthService()
    
    enum ResultRegistrate {
        case error(String)
        case succes
    }
   
    
    var haveAuth: Bool {

        return Auth.auth().currentUser != nil
    }
    
    
    func authWithEmail(withEmail email: String, withPassword pass: String, compleation: @escaping(ResultRegistrate)->Void){
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error {
                compleation(.error(error.localizedDescription))
            }
            if result != nil {
                compleation(.succes)
            }
        }
    }
    
    
    func registerUser(credentials: RegisterCredentials, compleation: @escaping(ResultRegistrate)->Void){
        ImageUploader.shared.uploadImage(path: "profile_image", image: credentials.imageProfile) { url, error in
            if let error = error {
                compleation(.error(error.localizedDescription))
            }
            
            guard let url = url else { return }
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (data, error) in
                
                if let error = error {
                    compleation(.error(error.localizedDescription))
                    return
                }
                
                guard let userUid = data?.user.uid else { return }
                
                
                var values = [String: Any]()
                values["username"] = credentials.username
                values["email"] = credentials.email
                values["imageProfileUrl"] = url
                values["fullname"] = credentials.fullname
                values["uid"] = userUid
                
                REF_USERS.document(userUid).setData(values) { (error) in
                    if error != nil {
                        compleation(.error(error!.localizedDescription))
                    }else{
                        compleation(.succes)
                    }
                }
            }
        }
    }
    
    
    func logOut() -> ResultRegistrate{
        do{
            try Auth.auth().signOut()
            return .succes
        }catch{
            return .error(error.localizedDescription)
        }
    }
    
    
}
