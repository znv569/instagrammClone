import UIKit
import Firebase

private let reusebleCell = "NotificationCell"

class NotificationController: UITableViewController {
    //MARK: Property
    
    private var notifications = [NotificationPost](){
        didSet{ tableView.reloadData() }
    }
    var listener: ListenerRegistration?
    
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(true)
    }
    
    init(){
        super.init(style: .plain)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchNotification()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    
    
    
    
    //MARK: Helpers
    func configureUI(){
        tableView.backgroundColor = .white
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reusebleCell)
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(tapRefresh), for: .valueChanged)
        
    }
    
    
    
    
    func fetchNotification(){
        listener?.remove()
        listener = NotificationService.shared.fetchNotifications { notitfications in
            self.notifications = notitfications
            self.showLoader(false)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    
    
    //MARK: Actions
    
    @objc func tapRefresh(){
        tableView.refreshControl?.beginRefreshing()
        fetchNotification()
    }
    
    
 
}




//MARK: Delegate DataSource
extension NotificationController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusebleCell, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}



//MARK: NotificationCellDelegate

extension NotificationController: NotificationCellDelegate {
    
    
    func handleFollow(_ cell: NotificationCell) {
        showLoader(true)
       let user = cell.viewModel!.userTo
        
        if user.follow {
            UserService.shared.userUnfollow(toUser: user) {
                cell.configure()
                self.showLoader(false)
            }
        }else{
            UserService.shared.userFollow(toUser: user) {
                cell.configure()
                self.showLoader(false)
            }
        }
    }
    
    
}
