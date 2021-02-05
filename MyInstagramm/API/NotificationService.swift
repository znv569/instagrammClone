//
//  NotificationService.swift
//  MyInstagramm
//
//  Created by Admin on 25.12.2020.
//

import Foundation
import Firebase



class NotificationService {
    
    static let shared = NotificationService()
    
    var currentUid: String {
        return Auth.auth().currentUser!.uid
    }
    
    func uploadNotification(type: NotificationPostType, toUser: User, post: Post? = nil){
        var value:[String: Any] = ["type": type.rawValue,
                                   "uid": currentUid,
                                   "timestamp": Timestamp(date: Date())]
        if let post = post {
            value["post"] = post.postId
        }
        
        REF_USERS.document(toUser.uid).collection("notification").addDocument(data: value)
    }
 
    
    func fetchNotifications(compleation: @escaping([NotificationPost]) -> Void) -> ListenerRegistration{
       let listener = REF_USERS.document(currentUid).collection("notification").order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else { return }
                
                var notifis = [NotificationPost]()
                let count = snapshot.count
                snapshot.documents.forEach { (document) in
                    
                    
                    let dictionary = document.data()
                    let userId = dictionary["uid"] as! String
                    
                    let timestamp: Date = (dictionary["timestamp"] as! Timestamp).dateValue()
                    
                        let type = NotificationPostType.init(rawValue: (dictionary["type"] as! Int))!
                    
                    UserService.shared.fetchUser(uid: userId) { user in
                        if type !=  .follow {
                            
                            let postId = dictionary["post"] as! String
                            PostsService.shared.getPost(postId: postId) { post in
                                let notif = NotificationPost(user: user, type: type, timestamp: timestamp, post: post)
                                notifis.append(notif)
                                
                                if notifis.count == count {
                                    notifis.sort{$0.timestamp > $1.timestamp}
                                    compleation(notifis)
                                }
                            }
                                
                            
                        }else{
                            UserService.shared.checkFollow(uid: user.uid) { follow in
                                user.follow = follow
                                let notif = NotificationPost(user: user, type: type, timestamp: timestamp)
                                notifis.append(notif)
                                if notifis.count == count {
                                    notifis.sort{$0.timestamp > $1.timestamp}
                                    compleation(notifis)
                                }
                            }
                           
                        }
                    
                    }
                           
                    
                    
                    
                }
        }
        return listener
    }
}
