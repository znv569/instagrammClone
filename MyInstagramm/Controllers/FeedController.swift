import UIKit
import SwiftIconFont
import Firebase
import SwiftUI

private let reusebleCell = "FeedCell"



class FeedController: UICollectionViewController {
    
    //MARK: Property
    enum ModeType{
        case loadPosts
        case openPost
    }
    
    var mode: ModeType
    
    var posts = [Post](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    
    
    
    private lazy var refresh: UIRefreshControl = {
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(handleRefreshCollection), for: .valueChanged)
        return ref
    }()
    
    var listener: ListenerRegistration?
    
    
    //MARK: Lifecycle
    init(mode: ModeType){
        self.mode = mode
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configureCollectionView()
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        if mode == .loadPosts {
            fetchPosts()
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }

    
    //MARK: Helpers
    

    
    
    func configureCollectionView(){
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reusebleCell)
        collectionView.backgroundColor = .white
        
        if mode == .loadPosts {
            //let logoutButton =  UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(handleLogout))
            let logoutButton =   UIBarButtonItem(image: UIImage(systemName: "airpodspro"), style: .done, target: self, action: #selector(handleLogout))
            //logoutButton.icon(from: .fontAwesome5Solid, code: "sign-out-alt", ofSize: 20)
            logoutButton.tintColor = .black
            navigationItem.leftBarButtonItem = logoutButton
            collectionView.refreshControl = refresh
           
        }
        
        
    }
    
    func fetchPosts(){
        refresh.beginRefreshing()
      listener?.remove()
        
      listener =  PostsService.shared.addListenePosts { (posts) in
            self.posts = posts
            self.refresh.endRefreshing()
        }
    }
    
    
    //MARK: Action
    
    
    @objc func handleRefreshCollection(){
        fetchPosts()
    }
    
    @objc func handleLogout(){
        
        let alert = UIAlertController(title: "Are you wanted logout?", message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            switch AuthService.shared.logOut() {
                case .error(let error):
                    self.showMessage(withTitle: "Error logout", message: error)
                case .succes:
                    let tab = UIApplication.shared.windows.filter{$0.isKeyWindow}.first!.rootViewController as! MainTabController
                    tab.checkAuth()
            }
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)

    }
    
}




//MARK: CollectionViewDataSource and Delegate

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusebleCell, for: indexPath) as! FeedCell
        
        cell.viewModel = FeedViewModel(posts[indexPath.row])
        cell.delegate = self
        return cell
        
    }
}




//MARK: UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 5 + 40 + 8
        height += 8 + 30 //stack
        height += 8 + 20 //likes
        height += 8 + 20 // caption
        height += 8 + 20 //times ago
        
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}




extension FeedController: FeedCellDelegate {
    
    func tapLike(cell: FeedCell) {
        guard let viewModel = cell.viewModel else { return }
        if viewModel.isLiked {
            PostsService.shared.unLike(post: viewModel.post) {
                cell.configure()
            }
        }else{
            PostsService.shared.setLike(post: viewModel.post) {
                cell.configure()
            }
        }
    }
    
    func tapComment(_ post: Post) {
        let controller = CommentsController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}


