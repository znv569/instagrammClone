import UIKit


protocol FeedCellDelegate: class {
    func tapComment(_ post: Post)
    func tapLike(cell: FeedCell)
}


class FeedCell: UICollectionViewCell {
    
    //MARK: Property
    var viewModel: FeedViewModel?{
        didSet{
            configure()
        }
    }
   weak var delegate: FeedCellDelegate?
    
    private let imageProfileView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapUsername))
        iv.addGestureRecognizer(tap)
        iv.setDimensions(height: 40, width: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    
    
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.setTitle("venom", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var photoView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapPhoto))
        tap.numberOfTapsRequired = 2
        iv.addGestureRecognizer(tap)
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let loader = UIActivityIndicatorView(style: .large)
    
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(tapComment), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(tapShare), for: .touchUpInside)
        return button
    }()
    
    
    private let likesLabel: UILabel = {
       let label = UILabel()
        label.text = "1 likes"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.text = "Some text caption for now...."
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let timesLabel: UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        
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
        backgroundColor = .white
        
        
        let stackButton = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackButton.axis = .horizontal
        stackButton.distribution = .fillEqually
        loader.startAnimating()
        
        loader.color = .black
        
        addSubview(imageProfileView)
        addSubview(usernameButton)
        addSubview(photoView)
        addSubview(loader)
        addSubview(stackButton)
        addSubview(likesLabel)
        addSubview(captionLabel)
        addSubview(timesLabel)
        
        imageProfileView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 4)
        usernameButton.centerY(inView: imageProfileView, leftAnchor: imageProfileView.rightAnchor, paddingLeft: 5)
        photoView.anchor(top: imageProfileView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, height: frame.width)
        loader.center(inView: photoView)
        stackButton.anchor(top: photoView.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4, width: 120, height: 30)
        likesLabel.anchor(top: stackButton.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        timesLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 4)
        
    }
    
    
    func configure(){
        
        guard let viewModel = viewModel else { return }
        
        imageProfileView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        usernameButton.setTitle(viewModel.username, for: .normal)
        
        photoView.sd_setImage(with: viewModel.imageUrl) { (_, _, _, _) in
            self.loader.stopAnimating()
        }
        
        likesLabel.text = viewModel.likes
        captionLabel.text = viewModel.caption
        timesLabel.text = viewModel.timeExpire
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtoColor
        
    }
    
    
    
    //MARK: Actions
    
    
    @objc func didTapUsername(){
        
        
    }
    
    @objc func tapLike(){
        delegate?.tapLike(cell: self)
        
    }
    
    @objc func doubleTapPhoto(){
       
    }
    
    @objc func tapComment(){
        guard let viewModel = viewModel else { return }
        delegate?.tapComment(viewModel.post)
    }
    
    
    @objc func tapShare(){
        
    }
    
}
