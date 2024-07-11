//
//  ObserverManager.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 6. 21..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit
import KakaoMapsSDK

class ObserverManager {
    static let BASE_ZOOM_LEVEL = 14
    static let APPLE_ID = "1501449207"
    static let testServer = false // 테스트용인지 체크
    static let isShowLog = true // Log 노출여부 체크
    static var isForeground = true // foreground background 체크
    
    static var root: BaseController! = MainController() // 현재 Controller
    
    static let DISTANCE: Double = 0.02
    
    static var currentToilet: Toilet = Toilet()
    
    static func isTestServer() -> Bool {
        return testServer
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
    
    /**
     * 앱의 스토어로 이동.
     */
    static func updateInPlayMarket() {
        // let appStoreLink = "itms-apps://itunes.apple.com/app/id\(APPLE_ID)?action=write-review" // 앱 스토어의 리뷰화면으로 바로이동
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(ObserverManager.APPLE_ID)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: {_ in exit(0)})
        }
    }
    
    /**
     * 앱의 스토어로 이동.
     */
    static func reviewInPlayMarket() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(ObserverManager.APPLE_ID)?action=write-review"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: {_ in exit(0)})
        }
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
        case "LoginController": // 로그인
            let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
            return controller
        case "JoinController": // 회원가입
            let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "JoinController") as! JoinController
            return controller
        case "TermsController": // 약관
            let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "TermsController") as! TermsController
            return controller
            
        // Menu.storyboard
        case "MyInfoController": // 로그인
            let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MyInfoController") as! MyInfoController
            return controller
        case "NoticeController": // 회원가입
            let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "NoticeController") as! NoticeController
            return controller
        case "SettingController": // 설정
            let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "SettingController") as! SettingController
            return controller
            
        // Main.storyboard
        case "HomeController": // 홈
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as! HomeController
            return controller
        case "ToiletController": // 화장실상세보기
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToiletController") as! ToiletController
            return controller
        case "ToiletSearchController": // 화장실등록 주소검색
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToiletSearchController") as! ToiletSearchController
            return controller
        case "ToiletCreateController": // 화장실등록
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToiletCreateController") as! ToiletCreateController
            return controller
        default:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController") as! MainController
            return controller
        }
    }
    
}
extension UIImage {

    func imageResize (sizeChange:CGSize)-> UIImage{

        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }

}
