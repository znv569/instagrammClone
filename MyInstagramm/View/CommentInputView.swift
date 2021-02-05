//
//  CommentInputView.swift
//  MyInstagramm
//
//  Created by Admin on 23.12.2020.
//

import UIKit

protocol CommentInputViewDelagate: class {
    func sendComment(_ message: String)
}

class CommentInputView: UIView {
    //MARK: Property
    
    weak var delegate: CommentInputViewDelagate?
    
    let inputTextView: CustomTextView = {
        let iv = CustomTextView()
        iv.placeholder = "Enter your comments...."
        return iv
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(tapSendButton), for: .touchUpInside)
        return button
    }()
    
    private let underline: UIView = {
       let vw = UIView()
        vw.backgroundColor = .lightGray
        vw.setHeight(0.4)
        return vw
    }()
    
    private var constraintForHeigth: NSLayoutConstraint?
        
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Helpers
    
    func configureUI(){
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        addSubview(underline)
        addSubview(inputTextView)
        addSubview(sendButton)
        
        underline.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        sendButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingBottom: 7, paddingRight: 5)
        inputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor,
                             paddingTop: 5, paddingLeft: 5, paddingBottom: 10, paddingRight: 5)
        constraintForHeigth = inputTextView.heightAnchor.constraint(equalToConstant: 50)
        constraintForHeigth?.isActive = true
        inputTextView.delegate = self
        
        
        
    }
    
    
    //MARK: Actions
    @objc func tapSendButton(){
        
        delegate?.sendComment(inputTextView.text)
        inputTextView.text = ""
        
    }
    
}



extension CommentInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

        
        
        var contentSizeHeight = textView.sizeThatFits(textView.bounds.size).height + 10

        if contentSizeHeight > UIScreen.main.bounds.height / 5{
            textView.isScrollEnabled = true
            contentSizeHeight = (UIScreen.main.bounds.height / 5) + 10
        } else {
            textView.isScrollEnabled = false
        }
        
        
        constraintForHeigth?.constant = contentSizeHeight
        
    }

}
