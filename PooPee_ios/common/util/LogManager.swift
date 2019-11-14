//
//  LogManager.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/11/12.
//  Copyright © 2019 ho1. All rights reserved.
//

import Foundation

class LogManager {
    static let TAG = "HO1_TEST"
    
    static func e(tag: String = TAG, message: Any) {
        if (ObserverManager.isShowLog) {
            print("\(tag) : \(message)")
        }
    }
    
}
