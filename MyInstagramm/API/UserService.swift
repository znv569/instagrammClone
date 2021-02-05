//
//  UserService.swift
//  MyInstagramm
//
//  Created by Admin on 17.12.2020.
//

import Foundation
import Firebase




class UserService {
    
    static let shared = UserService()
    
    
    var currentUId: String{
        return Auth.auth().currentUser?.uid ?? "-"
    }
    
    func fetchUser(uid: String? = nil, compleation: @escaping(User)->Void){
        
        var forQueryUid: String = ""
        if let uid = uid {
            forQueryUid = uid
        }else{
            guard let curUid = Auth.auth().currentUser?.uid else {   return }
            forQueryUid = curUid
        }
        
        REF_USERS.document(forQueryUid).getDocument { (snapshot, error) in
            
            guard let dictionary = snapshot?.data() else { return }
            let user = User(uid: forQueryUid, dictionary: dictionary)
            compleation(user)
            
        }
    }
    
    
    func fetchUsers(searchText: String? = nil, compleation: @escaping([User]) -> Void){
        
        
        var dbQuery: Query
        
        if let searchText = searchText, searchText != "" {
            
            dbQuery = REF_USERS.limit(to: 20).whereField("username", isGreaterThanOrEqualTo:  "\(searchText)").whereField("username", isLessThanOrEqualTo:  "\(searchText)~")
        }else{
            dbQuery = REF_USERS.limit(to: 20)
        }
        
        dbQuery.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            let users = snapshot.documents.map { User(uid: $0.documentID, dictionary: $0.data()) }
            
            compleation(users)
        }
        
        
    }
    
    
    func checkFollow(uid: String, compleation: @escaping(Bool)->Void){
        
        REF_FOLLOW.whereField("uid", isEqualTo: currentUId).whereField("toUser", isEqualTo: uid).getDocuments { (snapshot, error) in
            if error != nil {
                compleation(false)
            }else if let snapshot = snapshot{
                if snapshot.documents.count > 0 {
                    compleation(true)
                }else{
                    compleation(false)
                }
            }else{
                compleation(false)
            }
        }
        
    }
    
    
    func userFollow(toUser: User, compleation: @escaping()->Void){
        
        var value = [String: Any]()
        value["uid"] = currentUId
        value["toUser"] = toUser.uid

        
        REF_FOLLOW.addDocument(data: value) { error in
            if error == nil {
                toUser.follow = true
                compleation()
                NotificationService.shared.uploadNotification(type: .follow, toUser: toUser)
            }
        }
        
    }
    
    
    
    func userUnfollow(toUser: User, compleation: @escaping()->Void){
        REF_FOLLOW.whereField("uid", isEqualTo: currentUId).whereField("toUser", isEqualTo: toUser.uid).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            if let docDelete =  snapshot.documents.first?.documentID {
                REF_FOLLOW.document(docDelete).delete { error in
                    if error == nil {
                        toUser.follow = false
                        compleation()
                    }
                }
            }
            
        }
        
        
    }
    
    
    
    
    func setsInUserStats(user: User, compleation: @escaping()->Void){
        REF_FOLLOW.whereField("uid", isEqualTo: user.uid).getDocuments { (snapshot, _) in
            let following = snapshot!.count
            
            REF_FOLLOW.whereField("toUser", isEqualTo: user.uid).getDocuments { (snapshot, _) in
                
                let followers = snapshot!.count
                user.userstats = UserStats(following: following, followers: followers)
                compleation()
            }
        }
    }
    

    
    
}
