import UIKit

private let reusebleCellIdentifire = "UserCell"

class SearchController: UITableViewController {
    
    //MARK: Property
    var users: [User] = [User]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    
    
    
    
    //MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathSelected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathSelected, animated: true)
            tableView.reloadRows(at: [indexPathSelected], with: .none)
        }
        
    }
    
    init(){
        super.init(style: .plain)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        fetchUsers()
        
    }
    
    
    
    //MARK: Helpers
    
    func configureUI(){
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reusebleCellIdentifire)
        tableView.separatorStyle = .none
        
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search user"
        searchBar.delegate = self
        let leftButton  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAdd))
        navigationItem.rightBarButtonItems = [leftButton]
        
        navigationItem.titleView = searchBar
        
      
        
    }
    
    
    func fetchUsers(query: String? = nil){
        UserService.shared.fetchUsers(searchText: query) { (users) in
            self.users = users
        }
    }
    
    
    //MARK: Selectors
    
    @objc func pressAdd(){
        print("press add")
    }
}


//MARK: Table DataSource Delegate
extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusebleCellIdentifire, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = ProfileController(user: users[indexPath.row])
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}


//MARK: UISearchControllerDelegate

extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isEmpty {
            fetchUsers()
        }else{
            fetchUsers(query: query)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        fetchUsers()
    }
}
