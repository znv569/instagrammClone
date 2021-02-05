//
//  File.swift
//  MyInstagramm
//
//  Created by Admin on 22.12.2020.
//

import UIKit



class FeedViewModel {
    
    let post: Post
    
    
    var imageUrl: URL {
        return post.photoUrl
    }
    
    var likes: String {
        if post.likes > 1 {
            return "\(post.likes) likes"
        }else{
            return "\(post.likes) like"
        }
    }
    
    var isLiked: Bool {
        return post.isLiked
    }
    
    var caption: String {
        return post.caption
    }
    
    var likeButtoColor: UIColor {
        return post.isLiked ? .red : .black
    }
    
    var likeButtonImage: UIImage {
        return post.isLiked ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected")
    }
    
    
    var username: String {
        return post.user.username
    }
    
    var profileImageUrl: URL? {
        return post.user.imageProfileUrl
    }
    
    var timeExpire: String {
        return post.timestamp.dayExpire
    }
    
    init(_ post: Post){
        self.post = post
    }
    
    
    
}
