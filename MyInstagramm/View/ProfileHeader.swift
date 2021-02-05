//
//  ProfileHeader.swift
//  MyInstagramm
//
//  Created by Admin on 15.12.2020.
//

import UIKit
import SDWebImage


protocol ProfileHeaderDelegate: class{
    func handleMainButton()
}

class ProfileHeader: UICollectionReusableView {
   
    //MARK: Property
    
    
    var viewModel: ProfileViewModel?{
        
        didSet{
            configure()
        }
        
    }
    
   weak var delegate: ProfileHeaderDelegate?
    
    
    private let imageProfileView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 80 / 2
        iv.setDimensions(height: 80, width: 80)
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.text = "Bruce Waynee"
        return label
    }()
    
    
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        //label.attributedText = atributedText(value: 0, text: "posts")
        return label
    }()
    
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        //label.attributedText = atributedText(value: 0, text: "followers")
        return label
    }()
    
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
       // label.attributedText = atributedText(value: 0, text: "following")
        return label
    }()
    
    
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitle("Loading", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(handleMainButton), for: .touchUpInside)
        return button
    }()
    
    
    
    private let underline: UIView = {
       let vw = UIView()
        vw.backgroundColor = .lightGray
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        return vw
    }()
    
    
    
    
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    
    
    
    
    //MARK: LIfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    //MARK: Helpers
    func configureUI(){
        //MARK: addViews
        addSubview(imageProfileView)
        addSubview(fullnameLabel)
        
        let stack = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        addSubview(stack)
        addSubview(editProfileButton)
        addSubview(underline)
        
        
        let stackButton = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackButton.axis = .horizontal
        stackButton.distribution = .fillEqually
        
        
        addSubview(stackButton)
        
        //MARK: Constraints
        
        imageProfileView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 10)
        stack.centerY(inView: imageProfileView, leftAnchor: imageProfileView.rightAnchor, paddingLeft: 10, constant: 0)
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        fullnameLabel.anchor(top: imageProfileView.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        editProfileButton.anchor(top: fullnameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 30)
        underline.anchor(top: editProfileButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30)
        stackButton.anchor(top: underline.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10)
        
    }
    
    

    
    func  configure(){
        
        guard let viewModel = viewModel else { return }
        fullnameLabel.text = viewModel.fullname
        imageProfileView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        
        editProfileButton.setTitle(viewModel.textButton, for: .normal)
        editProfileButton.setTitleColor(viewModel.colorTextButton, for: .normal)
        editProfileButton.backgroundColor = viewModel.colorBackgroundButton
        
        followersLabel.attributedText = viewModel.followersText
        followingLabel.attributedText = viewModel.followingText
        postLabel.attributedText = viewModel.postsText
    }
    
    //MARK: Selectors
    
    @objc func handleMainButton(){
        delegate?.handleMainButton()
    }
    
}



/*
//MARK: - SwiftUI
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let controller = ProfileController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) -> UIViewController {
            return controller
        }
        
        func updateUIViewController(_ uiViewController: PeopleVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) {
            
        }
    }
}
*/
