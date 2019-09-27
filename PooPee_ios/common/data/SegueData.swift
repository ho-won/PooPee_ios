//
//  SegueData.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 7. 2..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation

class SegueData {
    public static let RESULT_OK = 1
    
    private var _segue_id = ""
    private var _action = ""
    private var _requestCode = 0
    private var _resultCode = 0
    private var _extras: [String : Any] = [:]
    
    
    var segue_id: String {
        get {
            return _segue_id
        }
        set(newVal){
            _segue_id = newVal
        }
    }
    
    var action: String {
        get {
            return _action
        }
        set(newVal){
            _action = newVal
        }
    }
    
    var requestCode: Int {
        get {
            return _requestCode
        }
        set(newVal){
            _requestCode = newVal
        }
    }
    
    var resultCode: Int {
        get {
            return _resultCode
        }
        set(newVal){
            _resultCode = newVal
        }
    }
    
    func putExtra(key: String, data: Any) {
        _extras[key] = data
    }
    
    func getStringExtra(key: String) -> String! {
        if (_extras[key] == nil) {
            return nil
        }
        return _extras[key] as? String
    }
    
    func getIntExtra(key: String) -> Int! {
        if (_extras[key] == nil) {
            return nil
        }
        return _extras[key] as? Int
    }
    
    func getExtra(key: String) -> Any! {
        if (_extras[key] == nil) {
            return nil
        }
        return _extras[key] as Any
    }
    
}
