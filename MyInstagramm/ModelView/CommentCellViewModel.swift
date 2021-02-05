//
//  CommentCellViewModel.swift
//  MyInstagramm
//
//  Created by Admin on 23.12.2020.
//

import UIKit



class CommentCellViewModel {
    let comment: Comment
    
    init(_ comment: Comment){
        self.comment = comment
    }
    
    var imageProfile: URL? {
        comment.user.imageProfileUrl
    }
    
    var commentAttrString: NSAttributedString {
        let attrString = NSMutableAttributedString(string: "@\(comment.user.username) ", attributes: [.foregroundColor : UIColor.black,
                                                                                                     .font : UIFont.boldSystemFont(ofSize: 13)])
        attrString.append(NSAttributedString(string: comment.comment + " - ", attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        attrString.append(NSAttributedString(string: comment.timestamp.dayExpire, attributes: [.foregroundColor: UIColor.lightGray,
                                                                                               .font: UIFont.systemFont(ofSize: 10)]))
        return attrString
    }
    
    var user: User{
        return comment.user
    }
    
    func size(width: CGFloat) -> CGFloat{
        let label = UILabel()
        label.setWidth(width - 70)
        label.attributedText = commentAttrString
        label.numberOfLines = 0
        let height = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + 20
        return height > 50 ? height : 50
    }
}
