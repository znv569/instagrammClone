import UIKit
import YPImagePicker


class MainTabController: UITabBarController {
    
    
    //MARK: Property
    var user: User?{
        didSet{
            configureControllers()
        }
    }
    
    
    
    
    //MARK: Lifecycle
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        checkAuth()
    }
    

    
    //MARK: Helpers
    
    
    func checkAuth(){
        if AuthService.shared.haveAuth {
            fetchUser()
        }else{
            DispatchQueue.main.async {
                let controller = LoginController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func configureControllers(){
        guard let user = user else { return }
        tabBar.tintColor = .black
        self.delegate = self
        
        
        
        
        
        let nav1 = makeWithNavController(controller: FeedController(mode: .loadPosts), imageName: "home_unselected", selectedImageName: "home_selected")
        let nav2 = makeWithNavController(controller: SearchController(), imageName: "search_unselected", selectedImageName: "search_selected")
        let nav3 = makeWithNavController(controller: ImageSelectorController(), imageName: "plus_unselected")
        let nav4 = makeWithNavController(controller: NotificationController(), imageName: "like_unselected", selectedImageName: "like_selected")
        let nav5 = makeWithNavController(controller: ProfileController(user: user), imageName: "profile_unselected", selectedImageName: "profile_selected")
        
        
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
        
        showLoader(false)
        
        if let feed = viewControllers?.first as? UINavigationController {
            print(feed)
        }
    }
    
    
    
    
    fileprivate func makeWithNavController(controller: UIViewController, imageName: String, selectedImageName: String? = nil, name: String? = nil) -> UINavigationController{
        
        let nav = UINavigationController(rootViewController: controller)
        nav.tabBarItem.image = UIImage(named: imageName)
        
        if let selectedImageName = selectedImageName {
          nav.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        }
        
        nav.tabBarItem.title = name
        return nav
        
    }
    
    func fetchUser(){
        showLoader(true)
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    
    
    //MARK: Actions
    
    
    func didFinishPickingMedia(_ picker: YPImagePicker){
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                let controller = UploadPostController(photo: selectedImage)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            }
        }
    }
    
    
}





//MARK: UITabBarControllerDelegate
extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2{
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)

            return false
        }
        
        return true
    }
}
