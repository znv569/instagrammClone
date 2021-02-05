//
//  Notification.swift
//  MyInstagramm
//
//  Created by Admin on 25.12.2020.
//

import UIKit


protocol NotificationCellDelegate: class {
    func handleFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    //MARK: Property
    var viewModel: NotificationViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private let imageProfileView: UIImageView = {
       let iv = UIImageView()
        iv.setDimensions(height: 40, width: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.layer.borderWidth = 0.2
        iv.layer.borderColor = UIColor.black.cgColor
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        let tap = UITapGestureRecognizer(target: self, action: nil)
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    
    private let notificationLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var followButton: UIButton = {
       let button = UIButton()
        button.isHidden = true
        button.layer.cornerRadius = 5
        button.setHeight(30)
        button.layer.borderWidth = 0.3
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        button.addTarget(self, action: #selector(tapFollow), for: .touchUpInside)
        return button
    }()
    
    
    
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: Helpers
    fileprivate func configureUI(){
        selectionStyle = .none
        
            contentView.addSubview(imageProfileView)
            contentView.addSubview(notificationLabel)
            contentView.addSubview(followButton)
        
        
        imageProfileView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 10, constant: 0)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 10)
        
        notificationLabel.anchor(top: topAnchor, left: imageProfileView.rightAnchor, bottom: bottomAnchor, right: followButton.leftAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
        
    }
    
    
    func configure(){
        guard let viewModel = viewModel else { return }
        imageProfileView.sd_setImage(with: viewModel.fromUserImageUrl, completed: nil)
        notificationLabel.attributedText = viewModel.userText
        followButton.isHidden = viewModel.buttonFollowIsHidden
        followButton.setTitle(viewModel.buttonText, for: .normal)
        followButton.setTitleColor(viewModel.buttonColor, for: .normal)
        followButton.layer.borderColor = viewModel.buttonBorderColor
        followButton.setWidth(viewModel.butonWidth)
    }
    
    
    //MARK: Actions
    
    @objc func tapFollow(){
        delegate?.handleFollow(self)
    }
    
    
}
