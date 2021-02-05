//
//  CommentService.swift
//  MyInstagramm
//
//  Created by Admin on 24.12.2020.
//

import Foundation
import Firebase



class CommentService {
    
    static let shared = CommentService()
    
    var currentUId: String{
        return Auth.auth().currentUser?.uid ?? "-"
    }
    
    enum CompleationStatus {
        case error(Error)
        case success
    }
    
    
    
    func sendComments(_ post: Post, comment: String, compleation: @escaping(CompleationStatus) -> Void = { _ in }) {
        
        let values: [String: Any] = ["uid": currentUId,
                                     "timestamp" : Timestamp(date: Date()),
                                     "comment" : comment]
        
        REF_POSTS.document(post.postId).collection("comment").addDocument(data: values) { error in
            
            if error == nil {
                compleation(.success)
            }else{
                compleation(.error(error!))
            }
            NotificationService.shared.uploadNotification(type: .comment, toUser: post.user, post: post)
        }
    }
    
    
    
    func addCommentsListener(post: Post, compleation: @escaping ([Comment]) -> Void) -> ListenerRegistration{
        
        let listener =  REF_POSTS.document(post.postId).collection("comment").order(by: "timestamp", descending: false).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else { return  }
            
        let count = snapshot.count
        var comments = [Comment]()
        snapshot.documents.forEach { document in
            
            let dictionary = document.data()
            let userUid = dictionary["uid"] as! String
            
            UserService.shared.fetchUser(uid: userUid) { user in
                let comment = Comment(user: user, dictionary: dictionary, id: document.documentID)
                
                comments.append(comment)
                
                if count == comments.count {
                    comments.sort{$0.timestamp < $1.timestamp}
                    compleation(comments)
                }
            }
            
        }
            
            if count == 0 { compleation(comments) }
        
       }
        return listener
    }
    
    
    
}

