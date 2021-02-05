//
//  Posts.swift
//  MyInstagramm
//
//  Created by Admin on 22.12.2020.
//

import Foundation
import Firebase



class Post {
    
    let caption: String
    let timestamp: Date
    var likes: Int
    let uid: String
    let photoUrl: URL
    let user: User
    let postId: String
    var isLiked: Bool = false
    var likeId: String?
    
    init(user: User, postId: String, dictionary: [String: Any]){
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        self.photoUrl = URL(string: dictionary["photoUrl"] as! String)!
        self.timestamp = (dictionary["timestamp"] as! Timestamp).dateValue()
        self.user = user
        self.postId = postId
        
    }
    
}
