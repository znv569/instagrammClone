


import UIKit





class ProfileCell: UICollectionViewCell {
    
    //MARK: Property
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    var post: Post?{
        didSet{ configure() }
    }
    
    private let loader: UIActivityIndicatorView = {
        let actIndi =  UIActivityIndicatorView()
        actIndi.color = .black
        actIndi.startAnimating()
        return actIndi
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
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        addSubview(loader)
        loader.center(inView: photoImageView)
    }
    
    func configure(){
        photoImageView.sd_setImage(with: post?.photoUrl) { (_, _, _, _) in
            self.loader.stopAnimating()
        }
    }
    
}
