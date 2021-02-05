//
//  LoginController.swift
//  MyInstagramm
//
//  Created by Admin on 14.12.2020.
//

import UIKit


class LoginController: UIViewController {
    
    //MARK: Property
    
    private let viewModel = LoginViewModel()
    
    private let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Instagram_logo_white")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    private lazy var loginField: UITextField = {
        
       let tf = CustomSubTextFieild(placeholder: "Email")
        
        
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        tf.delegate = self
        tf.resignFirstResponder()
        return tf
    }()
    
    
    private lazy var passwordField: UITextField = {
        
       let tf = CustomSubTextFieild(placeholder: "Password")
        tf.delegate = self
        
        tf.isSecureTextEntry = true
        tf.textContentType = .oneTimeCode
        return tf
        
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(50)
        button.layer.cornerRadius = 5
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.9486505389, green: 0.4501413703, blue: 1, alpha: 1).withAlphaComponent(0.2)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDoubleAttributedText(firstPart: "You don't have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDoubleAttributedText(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        return button
    }()
    
    
    //MARK: LIfeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    
   //MARK: Helpers
    
    func configureUI(){
        
        hideKeyboardOnTap(#selector(dismissKeyboard))
        
        //MARK: NavigationConfigure
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        //MARK: GradienConfigure
        configureGradientLayer()
        
        //MARK: AddElements
        view.addSubview(logoImageView)
        view.addSubview(loginField)
        
        let stack = UIStackView(arrangedSubviews: [loginField, passwordField, loginButton])
        stack.axis = .vertical
        stack.spacing  = 20
        
        view.addSubview(stack)
        view.addSubview(registerButton)
        view.addSubview(forgotPasswordButton)
        
        
        
        //MARK: Constraints
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        logoImageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.4).isActive = true
        
        
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 38, paddingRight: 38)
        forgotPasswordButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        registerButton.anchor( left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingBottom: 20, paddingRight: 10)
    }
    
    
    
    //MARK: Selectors
    
    @objc func handleSignUp(){
        let regController = RegistrationController()
        navigationController?.pushViewController(regController, animated: true)
    }
    
    @objc func handleLogin(){
        guard let login = loginField.text else { return }
        guard let password = passwordField.text else { return }
        
        showLoader(true)
        
        AuthService.shared.authWithEmail(withEmail: login, withPassword: password) { (result) in
            self.showLoader(false)
            switch result {
            case .error(let error):
                self.showMessage(withTitle: "Error auth", message: error)
            case .succes:
                guard let tab = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabController else { return }
                tab.checkAuth()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}



//MARK: UITextFieldDelegate
extension LoginController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if textField == loginField {
            viewModel.email = text
            
        }else if textField == passwordField {
            viewModel.password = text
        }
        
        loginButton.isEnabled = viewModel.isValidate
        loginButton.backgroundColor = viewModel.colorButton
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
            
    }
}
