//
//  RegistrationController.swift
//  MyInstagramm
//
//  Created by Admin on 14.12.2020.
//

import UIKit




class RegistrationController: UIViewController {
    
    //MARK: Propertys
    private let scrollView = UIScrollView()
    private var bottomScrollConstaraint: NSLayoutConstraint?
    private let viewModel = RegistrationViewModel()
    
    private var selectedImage: UIImage?
    
    private lazy var plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var emailTextField: CustomSubTextFieild = {
        let tf = CustomSubTextFieild(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        tf.delegate = self
        return tf
    }()
    
    private lazy var passwordTextField: CustomSubTextFieild = {
        let tf = CustomSubTextFieild(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.delegate = self
        return tf
    }()
    private lazy var fullnameTextField: CustomSubTextFieild = {
        let tf = CustomSubTextFieild(placeholder: "Fullname")
        tf.keyboardType = .default
        tf.textContentType = .name
        tf.delegate = self
        return tf
    }()
    private lazy var usernameTextField: CustomSubTextFieild = {
        let tf = CustomSubTextFieild(placeholder: "Username")
        tf.keyboardType = .default
        tf.textContentType = .username
        tf.delegate = self
        return tf
    }()
    
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(50)
        button.layer.cornerRadius = 5
        button.setTitle("Register", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.9486505389, green: 0.4501413703, blue: 1, alpha: 1).withAlphaComponent(0.2)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let buttonHaveAccount: UIButton = {
        let button = UIButton(type: .system)
        button.setDoubleAttributedText(firstPart: "Already have an account?", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return button
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureKeyboard()
    }
    
    
    
    //MARK: Helpers
    func configureUI(){
        
        
        scrollView.contentSize.height = 530
        hideKeyboardOnTap(#selector(dismissKeyboard))
        configureGradientLayer()
        
        //MARK: addSubViews
        view.addSubview(scrollView)
        scrollView.addSubview(plusPhotoButton)
        
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField, registerButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        scrollView.addSubview(stack)
        
        view.addSubview(buttonHaveAccount)
        
        
        //MARK: Constraints
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        bottomScrollConstaraint = scrollView.bottomAnchor.constraint(equalTo: buttonHaveAccount.topAnchor, constant: 0)
        bottomScrollConstaraint?.isActive = true
        
        plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.centerX(inView: view, topAnchor: scrollView.topAnchor, paddingTop: 20)
        
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 38, paddingRight: 38)
        
        buttonHaveAccount.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        
        
    }
    
    
    func configureKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: Selectors
    
    
    @objc func handleLogIn(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func kbWillShow(notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.bottomScrollConstaraint?.constant = -(kbFrameSize.height - self.view.safeAreaInsets.bottom - 10 - 20)
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func kbWillHide(notification: Notification){
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.bottomScrollConstaraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handlePlusPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text?.lowercased() else { return }
        guard let pass = passwordTextField.text?.lowercased() else { return }
        guard let fullname = fullnameTextField.text?.lowercased() else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let image = selectedImage else { return }
        
       let credentials = RegisterCredentials(email: email, password: pass, username: username, fullname: fullname, imageProfile: image)
        
        showLoader(true)
        AuthService.shared.registerUser(credentials: credentials) { result in
            
            self.showLoader(false)
            
            switch result {
            case .error(let error):
                self.showMessage(withTitle: "Error registrate", message: error)
            case .succes:
                
                guard let tab = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabController else {    return }
                tab.checkAuth()
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
}


//MARK: UITextFieldDelegate
extension RegistrationController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let text =  textField.text else { return }
        
        switch textField {
            case emailTextField:
                viewModel.email = text
            case passwordTextField:
                viewModel.password = text
            case fullnameTextField:
                viewModel.fullname = text
            case usernameTextField:
               viewModel.username = text
            default:
                return
        }
        
        butEnabled()
        
    }
    
    
    func butEnabled(){
        registerButton.isEnabled = viewModel.isValidate
        registerButton.backgroundColor = viewModel.colorButton
        registerButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
}



extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedPhoto = info[.editedImage] as? UIImage else { return }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.setImage(selectedPhoto.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        self.selectedImage = selectedPhoto
        
        viewModel.imageHave = true
        butEnabled()
        
        
        dismiss(animated: true, completion: nil)
        
    }
}
