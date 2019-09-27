//
//  Toilet.swift
//  PooPee_ios
//
//  Created by ho1 on 20/09/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import Foundation

class Toilet {
    static let VIEW_CONTENT = 1001
    static let VIEW_COMMENT = 1002
    
    var toilet_id: Int = 0
    var type: String = ""
    var name: String = ""
    var address_new: String = ""
    var address_old: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var comment_count: String = "0"
    var like_count: String = "0"
    var like_check: Bool = false
}
