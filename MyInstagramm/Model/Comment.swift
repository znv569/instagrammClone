//
//  Comment.swift
//  MyInstagramm
//
//  Created by Admin on 23.12.2020.
//

import Foundation
import Firebase


class Comment{
    let comment: String
    let timestamp: Date
    let user: User
    let idComent: String
    
    init(user: User, dictionary: [String: Any], id: String){
        self.comment = dictionary["comment"] as? String ?? ""
        self.timestamp = (dictionary["timestamp"] as? Timestamp)?.dateValue() ?? Date()
        self.user = user
        self.idComent = id
    }
}
