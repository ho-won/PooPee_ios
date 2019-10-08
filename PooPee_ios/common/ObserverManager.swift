//
//  ObserverManager.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 6. 21..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit

class ObserverManager {
    static let APPLE_ID = "1426273940"
    static let testServer = false // 테스트용인지 체크
    
    static var root: BaseController! = MainController() // 현재 Controller
    static var preRoot: BaseController! = MainController() // 직전 Controller
    
    static let DISTANCE: Double = 0.02
    
    static func isTestServer() -> Bool {
        return testServer
    }
    
    static func getRoot() -> BaseController {
        return root
    }
    
    static func setRoot(root: BaseController) {
        ObserverManager.root = root
    }
    
    static func getPreRoot() -> BaseController {
        return preRoot
    }
    
    static func setPreRoot(preRoot: BaseController) {
        ObserverManager.preRoot = preRoot
    }
    
    static func getPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    }
    
    static func logout() {
        SharedManager.instance.setLoginCheck(value: false)
        SharedManager.instance.setMemberId(value: "")
        SharedManager.instance.setMemberUsername(value: "")
        SharedManager.instance.setMemberPassword(value: "")
        SharedManager.instance.setMemberName(value: "")
        SharedManager.instance.setMemberGender(value: "1")
    }
    
    static func getController(name: String) -> BaseController {
        switch name {
        // Gallery.storyboard
        case "GalleryController": // 앨범목록
            let controller = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewController(withIdentifier: "GalleryController") as! GalleryController
            return controller
        case "CropImageController": // 이미지크롭
            let controller = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewController(withIdentifier: "CropImageController") as! CropImageController
            return controller
            
        // Login.storyboard
        case "LoginController": // 이미지크롭
            let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
            return controller
        case "JoinController": // 이미지크롭
            let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "JoinController") as! JoinController
            return controller

        // Main.storyboard
        case "HomeController": // 이미지크롭
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as! HomeController
            return controller
        default:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController") as! MainController
            return controller
        }
    }
    
}
