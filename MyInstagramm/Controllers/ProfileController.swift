import UIKit
import Firebase


private let reusebleCell = "ProfileCell"
private let reusebleHeader = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    //MARK: Property
    
    var user: User
    var header: ProfileHeader?
    var listener: ListenerRegistration?
    
    
    var posts = [Post](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    //MARK: Lifecycle
    
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configureUI()
        fetchStats()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchPosts()

    }
    

    
    //MARK: Helpers
    
    func configureUI(){
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: reusebleCell)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusebleHeader)
        collectionView.backgroundColor = .white
        navigationItem.title = user.username
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue,
                                                                   .font : UIFont.boldSystemFont(ofSize: 15)]
        
    }
    
    
    func fetchStats(){
        UserService.shared.setsInUserStats(user: user) {
            self.header?.configure()
        }
    }

    func fetchPosts(){
       listener?.remove()
        
       listener = PostsService.shared.addListenePosts(user: user) { posts in
            self.posts = posts
            self.showLoader(false)
            self.header?.configure()
        }
    }
    
    //MARK: Selectors
    
    
    
  
    
    
}




//MARK: UICollectionView DataSorce Delegate
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController(mode: .openPost)
        controller.posts.append(posts[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusebleCell, for: indexPath) as! ProfileCell
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusebleHeader, for: indexPath) as! ProfileHeader
        
        header = view
        view.delegate = self
        
        
            if user.isCurrentUser {
                view.viewModel = ProfileViewModel(user: user)
            }else{
                UserService.shared.checkFollow(uid: user.uid) { follow in
                    
                    self.user.follow = follow
                    view.viewModel = ProfileViewModel(user: self.user)
                    
                }
            }
        
        
        return view
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
}


//MARK: UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width ) / 3 - 3
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}



//MARK: ProfileHeaderDelegate


extension ProfileController: ProfileHeaderDelegate {
    
    func handleMainButton() {
        
        switch header?.viewModel?.mainButton {
        case .editProfile:
            print("Edit profile")
        case .unfollow:
            UserService.shared.userUnfollow(toUser: user) {
                self.header?.configure()
            }
        case .follow:
            UserService.shared.userFollow(toUser: user) {
                self.header?.configure()
            }
        case .none:
           print("DEBUG: nil in HeaderViewModel")
            
        }
       
    }
    
    
}
