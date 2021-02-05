//
//  ProfileViewModel.swift
//  MyInstagramm
//
//  Created by Admin on 17.12.2020.
//

import UIKit

enum ProfileButton{
    case unfollow
    case follow
    case editProfile
}


class ProfileViewModel{
    
    var user: User
    
    var mainButton: ProfileButton{
        if user.isCurrentUser {
            return .editProfile
        }
        return user.follow ? .unfollow : .follow
    }
    
    var fullname: String{
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return user.imageProfileUrl
    }
    
    var username: String {
        return user.username
    }
    
    var uid:String {
        return user.uid
    }
    
    
    var colorBackgroundButton: UIColor {
        
        
        switch mainButton {
        case .editProfile:
            return .white
        case .unfollow:
            return .white
        case .follow:
            return .systemBlue
            
        }
        
    }
    
    
    var colorTextButton: UIColor {
        
        switch mainButton {
        case .editProfile:
            return .black
        case .unfollow:
            return .black
        case .follow:
            return .white
            
        }
        
    }
    
    var textButton: String {
        
        switch mainButton {
        case .editProfile:
            return "Edit Profile"
        case .unfollow:
            return "Unfollow"
        case .follow:
            return "Follow"
            
        }
        
    }
    
    var followingText: NSAttributedString {
        atributedText(value: user.userstats?.following ?? 0, text: "following")
    }
    
    var postsText: NSAttributedString {
        atributedText(value: user.postsCount ?? 0, text: "posts")
    }
    
    var followersText: NSAttributedString {
        atributedText(value: user.userstats?.followers ?? 0, text: "followers")
    }
    
    
    init(user: User) {
        self.user = user
    }
    
    
    func atributedText(value: Int, text: String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: "\(value)\n", attributes: [.foregroundColor: UIColor.black,
                                                                                      .font : UIFont.boldSystemFont(ofSize: 14)])
        attrString.append(NSAttributedString(string: text, attributes: [.foregroundColor : UIColor.lightGray,
                                                                        .font : UIFont.systemFont(ofSize: 13)]))
        return attrString
        
    }
    
    
}
