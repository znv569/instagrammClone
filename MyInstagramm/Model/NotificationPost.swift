//
//  Notification.swift
//  MyInstagramm
//
//  Created by Admin on 25.12.2020.
//

import Foundation


enum NotificationPostType: Int, CaseIterable {
    case like
    case comment
    case follow
    
    var messageNotification: String{
        switch self {
    
        case .like:
            return "like your post"
        case .comment:
            return "comment your post"
        case .follow:
            return "to follow you"
        }
    }
}

class NotificationPost {
    
    let type: NotificationPostType
    let user: User
    var post: Post?
    let timestamp: Date
    
    init(user: User, type: NotificationPostType, timestamp: Date, post: Post? = nil) {
        self.user = user
        self.type = type
        self.post = post
        self.timestamp = timestamp
    }
}
