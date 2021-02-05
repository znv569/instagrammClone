//
//  CommentsController.swift
//  MyInstagramm
//
//  Created by Admin on 23.12.2020.
//

import UIKit
import Firebase

private let reusebleCell = "CommentCell"

class CommentsController: UICollectionViewController {
    
    
    //MARK: Property
    let post: Post
    
    var listener: ListenerRegistration?
   
    
    
    private var comments = [Comment](){
        didSet { collectionView.reloadData() }
    }
    
    private lazy var commnetInputView: CommentInputView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let iv = CommentInputView(frame: frame)
        return iv
    }()
    
    override var inputAccessoryView: UIView? {
        return commnetInputView 
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //MARK: Lifecycle
    init(post: Post){
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        fetchComments()
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        print("Контроллер закрыт")
    }
    
    
    //MARK: Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reusebleCell)
        collectionView.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true
        commnetInputView.delegate = self
        hideKeyboardOnTap(#selector(handlerHideKeyboard), viewTap: collectionView)
    }
    
    func fetchComments(){
        listener = CommentService.shared.addCommentsListener(post: post, compleation: { (comments) in
            self.showLoader(false)
            self.comments = comments
        })
    }
    
   
    
    //MARK: Actions
    @objc func kbDidShow(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.comments.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
       
    }
    

    
    
    
    @objc func handlerHideKeyboard(){
        if UIApplication.shared.isKeyboardPresented {
            commnetInputView.inputTextView.resignFirstResponder()
        }
    }
    
}


//MARK: UICollection DataSource Delegate


extension CommentsController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusebleCell, for: indexPath) as! CommentCell
        cell.sizeToFit()
        cell.viewModel = CommentCellViewModel(comments[indexPath.row])
        cell.delegate = self
        return cell
    }
}



//MARK: UICollectionViewDelegateFlowLayout
extension CommentsController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let viewModel = CommentCellViewModel(comments[indexPath.row])
        let height = viewModel.size(width: width)
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}



//MARK: CommentsControlle


extension CommentsController: CommentInputViewDelagate {
    
    
    
    func sendComment(_ message: String) {
       
        showLoader(true)
        CommentService.shared.sendComments(post, comment: message) { (compleation) in
            
            self.showLoader(false)
            
            switch compleation {
            case .error(let error):
                self.showMessage(withTitle: "Error upload post", message: error.localizedDescription)
            case .success:
                print("success")
            }
        }
        commnetInputView.inputTextView.resignFirstResponder()
    }
    
    
    
    
}




extension CommentsController: CommentCellDelegate {
    
    func handleGoToProfile(_ user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
