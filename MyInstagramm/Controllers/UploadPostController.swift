//
//  UploadPost.swift
//  MyInstagramm
//
//  Created by Admin on 22.12.2020.
//

import UIKit




class UploadPostController: UIViewController {
    //MARK: Properties
    private let photoImage: UIImage
    
    
    private lazy var photoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = photoImage
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.layer.borderWidth = 0.3
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
   
    
    private let captionTextView: CustomTextView = {
       let tv = CustomTextView()
        tv.placeholder = "Enter caption for photo..."
        
        
        return tv
    }()
    
    //MARK: Lifecycle
    
    init(photo: UIImage){
        self.photoImage = photo
        super.init(nibName: nil, bundle: nil)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Helpers
    
    func configureUI(){
        view.addSubview(photoImageView)
        view.addSubview(captionTextView)
        
        view.backgroundColor = .white
        
        photoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        photoImageView.setDimensions(height: view.frame.width * 0.6, width: view.frame.width * 0.5)
        
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10)
        captionTextView.setHeight(view.frame.width * 0.3)
        
        view.addSubview(captionTextView.countLabel)
        captionTextView.countLabel.anchor(top: captionTextView.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 10)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(tapShare))
        
    }
    
    
    //MARK: Actions
    
    
    @objc func tapCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapShare(){
        showLoader(true)
        PostsService.shared.uploadPost(image: photoImage, caption: captionTextView.text) { (status) in
            
            self.showLoader(false)
           
            switch status {
            case .error(let error):
                self.showMessage(withTitle: "Error upload post", message: error.localizedDescription)
            case .success:
                self.dismiss(animated: true, completion: nil)
            }
        
        }
    }
    
    
}
