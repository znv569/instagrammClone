//
//  NotificationCellView.swift
//  MyInstagramm
//
//  Created by Admin on 25.12.2020.
//

import UIKit



class NotificationViewModel {
    
    let notification: NotificationPost
    
    var fromUserImageUrl: URL? {
        return notification.user.imageProfileUrl
    }
    
    var userTo: User {
        return notification.user
    }
    
    var userText: NSAttributedString {
        let attrString = NSMutableAttributedString(string: "@\(notification.user.username) ", attributes: [.foregroundColor : UIColor.black,
                                                                                                     .font : UIFont.boldSystemFont(ofSize: 13)])
        attrString.append(NSAttributedString(string: notification.type.messageNotification + " - ", attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        attrString.append(NSAttributedString(string: notification.timestamp.dayExpire, attributes: [.foregroundColor: UIColor.lightGray,
                                                                                               .font: UIFont.systemFont(ofSize: 10)]))
        return attrString
        
    }
    
    var buttonFollowIsHidden: Bool {
        return notification.type != .follow
    }
    
    
    var buttonColor: UIColor {
        return notification.user.follow ? .black : .blue
    }
    
    var buttonText: String {
        return notification.user.follow ? "UnFollow" : "Follow"
    }
    
    var buttonBorderColor: CGColor {
        return buttonColor.cgColor
    }
    
    
    var butonWidth: CGFloat {
        return buttonFollowIsHidden ? 0 : 90
    }
    
    
    init(notification: NotificationPost){
        self.notification = notification
    }
    
    
    
    
}
