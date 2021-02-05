import Foundation
import Firebase


let REF_USERS = Firestore.firestore().collection("users")
let REF_POSTS = Firestore.firestore().collection("posts")
let REF_FOLLOW = Firestore.firestore().collection("follow")
