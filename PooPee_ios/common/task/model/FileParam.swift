//
//  FileParam.swift
//  base_ios
//
//  Created by Jung ho Seo on 2019. 4. 5..
//  Copyright © 2019년 EMEYE. All rights reserved.
//

import Foundation

class FileParam {
    private var _key = ""
    private var _file_data: Data!
    
    var key: String {
        get {
            return _key
        }
        set(newVal){
            _key = newVal
        }
    }
    
    var file_data: Data! {
        get {
            return _file_data
        }
        set(newVal){
            _file_data = newVal
        }
    }
}
