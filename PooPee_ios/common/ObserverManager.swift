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
    static let isShowLog = true // Log 노출여부 체크
    
    static var root: BaseController! = MainController() // 현재 Controller
    static var preRoot: BaseController! = MainController() // 직전 Controller
    
    static let DISTANCE: Double = 0.02
    
    static var mapView: MTMapView!
    static let imageMaker = UIImage(named: "ic_position")!
    
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
    
    static func addPOIItem(toilet: Toilet) {
        let marker = MTMapPOIItem()
        marker.itemName = toilet.name
        marker.tag = toilet.toilet_id
        marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: toilet.latitude, longitude: toilet.longitude))
        marker.markerType = MTMapPOIItemMarkerType.customImage // 마커타입을 커스텀 마커로 지정.
        marker.customImage = imageMaker // 마커 이미지.
        marker.markerSelectedType = MTMapPOIItemMarkerSelectedType.customImage // 마커를 클릭했을때, 기본으로 제공하는 RedPin 마커 모양.
        marker.customSelectedImage = imageMaker
        marker.customImageAnchorPointOffset = MTMapImageOffset(offsetX: 30, offsetY: 0)
        mapView.add(marker)
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
        case "SettingController": // 약관
            let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "SettingController") as! SettingController
            return controller
            
        // Main.storyboard
        case "HomeController": // 홈
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as! HomeController
            return controller
        case "ToiletController": // 화장실상세보기
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToiletController") as! ToiletController
            return controller
        default:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController") as! MainController
            return controller
        }
    }
    
}
