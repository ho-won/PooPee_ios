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
    static let APPLE_ID = "1501449207"
    static let testServer = false // 테스트용인지 체크
    static let isShowLog = true // Log 노출여부 체크
    static var isForeground = true // foreground background 체크
    
    static var root: BaseController! = MainController() // 현재 Controller
    
    static let DISTANCE: Double = 0.02
    
    static var mapView: MTMapView!
    static let imageMaker = UIImage(named: "ic_position")!.imageResize(sizeChange: CGSize(width: 14, height: 16))
    static let imageMakerUp = UIImage(named: "ic_position_up")!.imageResize(sizeChange: CGSize(width: 14, height: 16))
    static let imageMe = UIImage(named: "ic_marker")!.imageResize(sizeChange: CGSize(width: 30, height: 30))
    static var my_position: MTMapPOIItem! = nil
    static var my_position_rotation: Float = 0
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
    
    static func addPOIItem(toilet: Toilet) {
        var image: UIImage! = imageMaker
        if (toilet.toilet_id < 0) {
            image = imageMakerUp
        }
        let marker = MTMapPOIItem()
        marker.itemName = toilet.name
        marker.tag = toilet.toilet_id
        marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: toilet.latitude, longitude: toilet.longitude))
        marker.markerType = MTMapPOIItemMarkerType.customImage // 마커타입을 커스텀 마커로 지정.
        marker.customImage = image // 마커 이미지.
        marker.markerSelectedType = MTMapPOIItemMarkerSelectedType.customImage // 마커를 클릭했을때, 기본으로 제공하는 RedPin 마커 모양.
        marker.customSelectedImage = image
        
        let imageOffset = Int32(image.size.height)
        marker.customImageAnchorPointOffset = MTMapImageOffset(offsetX: imageOffset, offsetY: imageOffset)
        mapView.add(marker)
    }
    
    static func addMyPosition(latitude: Double, longitude: Double) {
        if (my_position != nil) {
            mapView.remove(my_position)
        }
        
        my_position = MTMapPOIItem()
        my_position.itemName = "내위치"
        my_position.tag = -1
        my_position.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
        my_position.markerType = MTMapPOIItemMarkerType.customImage // 마커타입을 커스텀 마커로 지정.
        my_position.customImage = imageMe // 마커 이미지.
        my_position.markerSelectedType = MTMapPOIItemMarkerSelectedType.customImage // 마커를 클릭했을때, 기본으로 제공하는 RedPin 마커 모양.
        my_position.customSelectedImage = imageMe
        
        let imageOffset = Int32(imageMe.size.height)
        my_position.customImageAnchorPointOffset = MTMapImageOffset(offsetX: imageOffset, offsetY: imageOffset)
        mapView.add(my_position)
        my_position.rotation = my_position_rotation
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
