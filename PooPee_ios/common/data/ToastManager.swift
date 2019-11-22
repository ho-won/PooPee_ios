//
//  ToastManager.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 6. 26..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit

class ToastManager {
    
    static func showToast(rst_code: Int, msg: String) {
        if (msg.count > 0) {
            ObserverManager.root.view.makeToast(message: msg)
            return
        }
        
        switch (rst_code) {
        case 9:
            ObserverManager.root.view.makeToast(message: "toast_loading_fail".localized)
            break
        default:
            break
        }
    }
    
}
