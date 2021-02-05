//
//  customTextView.swift
//  MyInstagramm
//
//  Created by Admin on 22.12.2020.
//

import UIKit



class CustomTextView: UITextView {
    
    //MARK: Property
    
    var placeholder: String? {
        didSet{ placeholderLabel.text = placeholder }
    }
    
 
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let countLabel: UILabel = {
       let label = UILabel()
        label.text = "0/100"
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .lightGray

        return label
    }()
    
    
    
    //MARK: Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 10)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Helpers
    
    
    
    @objc func textDidChange(){
        placeholderLabel.isHidden = !text.isEmpty
        countLabel.text = "\(text.count)/100"
        if(text.count > 100){
            let start = text.index(text.startIndex, offsetBy: 0)
            let end = text.index(text.startIndex, offsetBy: 99)
            let range = start..<end
            text = String( text[range] )
        }
        
    }
    

    
}
