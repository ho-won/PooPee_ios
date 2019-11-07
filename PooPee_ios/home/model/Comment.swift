//
//  Comment.swift
//  PooPee_ios
//
//  Created by ho1 on 20/09/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import Foundation

class Comment {
    var comment_id: String = ""
    var member_id: String = ""
    var gender: String = "0" // 0(남자) 1(여자)
    var name: String = ""
    var content: String = ""
    var created: String = ""
    var view_type: Int = Toilet.VIEW_COMMENT
}
