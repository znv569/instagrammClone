//
//  CommentCell.swift
//  MyInstagramm
//
//  Created by Admin on 23.12.2020.
//

import UIKit

protocol CommentCellDelegate: class {
    func handleGoToProfile(_ user: User)
}

class CommentCell: UICollectionViewCell {
    
    
    //MARK: Property
    
    var viewModel: CommentCellViewModel?{
        didSet { configure() }
    }
    
    weak var delegate: CommentCellDelegate?
    
    private lazy var imageProfileView: UIImageView = {
       let iv = UIImageView()
        iv.setDimensions(height: 40, width: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.layer.borderWidth = 0.2
        iv.layer.borderColor = UIColor.black.cgColor
        iv.contentMode = .scaleAspectFill
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageProfile))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "The comment"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    
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
        addSubview(imageProfileView)
        addSubview(commentLabel)
        
        
        imageProfileView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        commentLabel.anchor(top: topAnchor, left: imageProfileView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
    }
    
    func configure(){
        guard let viewModel = viewModel else { return }
        imageProfileView.sd_setImage(with: viewModel.imageProfile, completed: nil)
        commentLabel.attributedText = viewModel.commentAttrString
    }
    
    //MARK: Actions
    @objc func tapImageProfile(){
        guard let viewModel = viewModel else { return }
        delegate?.handleGoToProfile(viewModel.user)
    }
    
}
