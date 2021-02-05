import UIKit



class UserCell: UITableViewCell {
    
    
    var user: User? {
        didSet{
            configure()
        }
    }
    
    //MARK: Property
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 40, width: 40)
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 40 / 2
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "zaremban"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.text = "Nikita Zaremba"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let underline: UIView = {
        let vw = UIView()
        vw.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        vw.backgroundColor = .lightGray
        return vw
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
    
    func configureUI(){
        contentView.addSubview(profileImageView)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        addSubview(stack)
        
        contentView.addSubview(stack)
        contentView.addSubview(underline)
        
        
        
        
        
        profileImageView.centerY(inView: contentView, leftAnchor: leftAnchor, paddingLeft: 10, constant: 0)
        stack.centerY(inView: self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 20, constant: 0)
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        underline.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        
    }
    
    
    func configure(){
        guard let user = user else { return }
        fullnameLabel.text = user.fullname
        usernameLabel.text = user.username
        profileImageView.sd_setImage(with: user.imageProfileUrl, completed: nil)
    }
}



