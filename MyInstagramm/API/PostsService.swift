//
//  PostsService.swift
//  MyInstagramm
//
//  Created by Admin on 22.12.2020.
//

import UIKit
import Firebase

class PostsService {
    
    static let shared = PostsService()
    
    var currentUId: String{
        return Auth.auth().currentUser?.uid ?? "-"
    }
    
    enum CompleationStatus {
        case error(Error)
        case success
    }
    
    func uploadPost(image: UIImage, caption: String, compleation: @escaping(CompleationStatus) -> Void = { _ in }){
        
        ImageUploader.shared.uploadImage(path: "posts", image: image) { (url, error) in
            
            if let url = url {
                
                let value: [String: Any] = ["uid": self.currentUId,
                                            "photoUrl": url,
                                            "likes": 0,
                                            "timestamp": Timestamp(date: Date()),
                                            "caption": caption]
                
                REF_POSTS.addDocument(data: value) { error in
                    if let error = error {
                        compleation(.error(error))
                    }else{
                        compleation(.success)
                    }
                }
                
            }else{
                compleation(.error(error!))
            }
        }
    }
    
    
    
    func addListenePosts(user: User? = nil, compleation: @escaping ([Post]) -> Void) -> ListenerRegistration{
        
        var listener: ListenerRegistration
        
        if let user = user {
            listener = REF_POSTS.whereField("uid", isEqualTo: user.uid).order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, _) in
                
                if let snapshot = snapshot {
                    user.postsCount = snapshot.documents.count
                }
                
                self.fetchPosts(snapshot: snapshot, compleation: compleation)
            }
        }else{
            listener = REF_POSTS.order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, _) in
                
                if let snapshot = snapshot, let user = user {
                    user.postsCount = snapshot.documents.count
                }
                
                self.fetchPosts(snapshot: snapshot, compleation: compleation)
            }
        }
        
        return listener
        
    }
    
    
    
    
    func getPosts(user: User, compleation: @escaping ([Post]) -> Void){
        REF_POSTS.order(by: "timestamp", descending: true).whereField("uid", isEqualTo: user.uid).getDocuments { (snapshot, _) in
            
            if let snapshot = snapshot {
                user.postsCount = snapshot.documents.count
            }
            
            self.fetchPosts(snapshot: snapshot, compleation: compleation)
            
        }
    }
    
    
    
    
    
    fileprivate func fetchPosts(snapshot: QuerySnapshot?, compleation: @escaping ([Post]) -> Void){
        if let snapshot = snapshot {
            
            var posts = [Post]()
            let count = snapshot.count
            
            snapshot.documents.forEach { document in
                
                guard let dictionary = document.data() as [String: Any]? else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let postId = document.documentID
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let post = Post(user: user, postId: postId, dictionary: dictionary)
                    self.checkLike(post: post) { isLiked in
                        
                        post.isLiked = isLiked
                        posts.append(post)
                        
                        if count == posts.count {
                            posts.sort{$0.timestamp > $1.timestamp}
                            compleation(posts)
                        }
                    }
                        
                    
                }
            }
            if count == 0 { compleation(posts) }
        }
    }
    
    
    
    
    func setLike(post: Post, compleation: @escaping () -> Void = { }){
        let value: [String: Any] = ["uid": currentUId]
        checkLike(post: post) { isLiked in
            if !isLiked {
                REF_USERS.document(self.currentUId).collection("user_likes").document(post.postId).setData(["postId": post.postId, "timestamp": Timestamp(date: Date())])
                
               let doc = REF_POSTS.document(post.postId).collection("likes").addDocument(data: value) { _ in
                REF_POSTS.document(post.postId).updateData(["likes": FieldValue.increment(Int64(1)) ])
                NotificationService.shared.uploadNotification(type: .like, toUser: post.user, post: post)
                    post.isLiked = true
                    post.likes += 1
                    compleation()
                }
                
                post.likeId = doc.documentID
            }else{
                post.isLiked = true
                compleation()
            }
        }
       
    }
    
    
    func checkLike(post: Post, compleation: @escaping (Bool) -> Void ){
        REF_POSTS.document(post.postId).collection("likes").whereField("uid", isEqualTo: currentUId).getDocuments { (snapshot, error) in
            post.likeId = snapshot?.documents.first?.documentID
            compleation(snapshot?.count ?? 0 > 0)
        }
    }
    
    func unLike(post: Post, compleation: @escaping () -> Void = { }){
        if let likeId = post.likeId {
            REF_POSTS.document(post.postId).collection("likes").document(likeId).delete { (_) in
                REF_POSTS.document(post.postId).updateData(["likes": FieldValue.increment(Int64(-1)) ])
                REF_USERS.document(self.currentUId).collection("user_likes").document(post.postId).delete()
                post.isLiked = false
                post.likes -= 1
                compleation()
            }
        }
    }
    
    func getPost(postId: String, compleation: @escaping (Post) -> Void){
        REF_POSTS.document(postId).getDocument { (snapshot, error) in
            let dictionary: [String: Any] = snapshot!.data() ?? [:]
            
            let uid = dictionary["uid"] as! String
            
            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(user: user, postId: postId, dictionary: dictionary)
                compleation(post)
            }
            
        }
    }
    
    
}
