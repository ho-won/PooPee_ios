//
//  ToiletCreateController.swift
//  PooPee_ios
//
//  Created by ho1 on 2020/10/15.
//  Copyright © 2020 ho1. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import KakaoMapsSDK

class ToiletCreateController: BaseController, MapControllerDelegate, CLLocationManagerDelegate {
    static let KAKAO_KEYWORD = "KaKaoKeyword"
    
    @IBOutlet var tv_toolbar_title: UIButton!
    
    @IBOutlet var map_view: KMViewContainer!
    
    @IBOutlet var layout_ex: UIView!
    @IBOutlet var tv_ex: UILabel!
    
    @IBOutlet var btn_my_position: UIButton!
    @IBOutlet var btn_bottom: UIButton!
    
    @IBOutlet var ad_view: AdView!
    @IBOutlet var ad_view_height: NSLayoutConstraint!
    
    var mLocationManager = CLLocationManager()
    
    var mKeyword: KaKaoKeyword? = nil
    
    var kakaoMap: KakaoMap!
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear: Bool = false
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        
        layout_ex.layer.cornerRadius = 14
        
        tv_toolbar_title.setTitle("toilet_create_text_03".localized, for: .normal)
        tv_ex.text = "toilet_create_text_04".localized
        btn_bottom.setTitle("toilet_create_text_05".localized, for: .normal)
        
        ad_view.loadBannerAd()
        
        _init()
        setListener()
    }
    
    func _init() {
        if (CLLocationManager.locationServicesEnabled()) {
            mLocationManager = CLLocationManager()
            mLocationManager.delegate = self
            mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            mLocationManager.requestAlwaysAuthorization()
            mLocationManager.startUpdatingLocation()
        }
        
        mKeyword = segueData.getExtra(key: ToiletCreateController.KAKAO_KEYWORD) as? KaKaoKeyword
        
        mapController = KMController(viewContainer: map_view)
        mapController?.delegate = self
        mapController?.prepareEngine()
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        btn_my_position.setOnClickListener {
            if (SharedManager.instance.getLatitude() > 0) {
                self.kakaoMap!.moveCamera(CameraUpdate.make(target: MapPoint(longitude: SharedManager.instance.getLongitude(), latitude: SharedManager.instance.getLatitude()), zoomLevel: ObserverManager.BASE_ZOOM_LEVEL, rotation: 0, tilt: 0, mapView: self.kakaoMap!))
                self.kakaoMap.moveCamera(CameraUpdate.make(zoomLevel: ObserverManager.BASE_ZOOM_LEVEL, mapView: self.kakaoMap))
            }
        }
        btn_bottom.setOnClickListener {
            let position = self.kakaoMap.getPosition(CGPoint(x: self.map_view.frame.width * 0.5, y: self.map_view.frame.height * 0.5))
            let dialog = ToiletCreateDialog(
                position.wgsCoord.latitude,
                position.wgsCoord.longitude,
                onToiletCreate: {
                    self.segueData.resultCode = SegueData.RESULT_OK
                    self.finish()
                }
            )
            dialog.show(view: ObserverManager.root.view)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        SharedManager.instance.setLatitude(value: locValue.latitude)
        SharedManager.instance.setLongitude(value: locValue.longitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()  //렌더링 중지.
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            LogManager.e("지도 종료(API인증 파라미터 오류)")
            break;
        case 401:
            LogManager.e("지도 종료(API인증 키 오류)")
            break;
        case 403:
            LogManager.e("지도 종료(API인증 권한 오류)")
            break;
        case 429:
            LogManager.e("지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            LogManager.e("지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break;
        default:
            break;
        }
    }
    
    func addViews() {
        var defaultPosition = MapPoint(longitude: 127.108678, latitude: 37.402001)
        if (SharedManager.instance.getLatitude() > 0) {
            defaultPosition = MapPoint(longitude: SharedManager.instance.getLongitude(), latitude: SharedManager.instance.getLatitude())
        }
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: ObserverManager.BASE_ZOOM_LEVEL)
        
        //KakaoMap 추가.
        mapController?.addView(mapviewInfo)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.kakaoMap = self.mapController?.getView("mapview") as? KakaoMap
            if (self.mKeyword != nil) {
                // 카카오검색기준으로 중심점변경
                self.kakaoMap!.moveCamera(CameraUpdate.make(target: MapPoint(longitude: self.mKeyword!.longitude, latitude: self.mKeyword!.latitude), zoomLevel: ObserverManager.BASE_ZOOM_LEVEL, rotation: 0, tilt: 0, mapView: self.kakaoMap!))
            } else if (SharedManager.instance.getLatitude() > 0) {
                // 현재위치기준으로 중심점변경
                self.kakaoMap!.moveCamera(CameraUpdate.make(target: MapPoint(longitude: SharedManager.instance.getLongitude(), latitude: SharedManager.instance.getLatitude()), zoomLevel: ObserverManager.BASE_ZOOM_LEVEL, rotation: 0, tilt: 0, mapView: self.kakaoMap!))
            }
        })
    }

    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
    
    func viewWillDestroyed(_ view: ViewBase) {
        
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
        _observerAdded = true
    }
     
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)

        _observerAdded = false
    }
    
    @objc func willResignActive(){
        mapController?.pauseEngine()
    }

    @objc func didBecomeActive(){
        mapController?.activateEngine()
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        for subview in map_view.subviews {
            subview.removeFromSuperview()
        }
        finish()
    }
    
}
