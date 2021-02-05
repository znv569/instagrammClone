//
//  User.swift
//  MyInstagramm
//
//  Created by Admin on 17.12.2020.
//

import Foundation
import Firebase



class User {
    var imageProfileUrl: URL?
    var email: String
    var username: String
    var uid: String
    var fullname: String
    var follow: Bool = false
    var userstats: UserStats?
    var postsCount: Int?
    
    var isCurrentUser: Bool{
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: Any]) {
        self.imageProfileUrl = URL(string: dictionary["imageProfileUrl"] as? String ?? "")
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
    }
}




struct UserStats {
    var following: Int
    var followers: Int
}
