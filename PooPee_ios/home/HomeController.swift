//
//  HomeController.swift
//  base_ios
//
//  Created by Jung ho Seo on 2019. 4. 11..
//  Copyright © 2019년 EMEYE. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import Lottie
import GoogleMobileAds
import KakaoMapsSDK
import SafariServices

class HomeController: BaseController, MapControllerDelegate, KakaoMapEventDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet var map_view: KMViewContainer!
    
    @IBOutlet var lottie_my_position: LottieAnimationView!
    
    @IBOutlet var btn_menu: UIButton!
    @IBOutlet var btn_menu_marginTop: NSLayoutConstraint!
    
    @IBOutlet var layout_my_position: bg_my_position!
    @IBOutlet var layout_my_position_marginTop: NSLayoutConstraint!
    @IBOutlet var tv_my_position: UILabel!
    
    @IBOutlet var layout_bottom_bg: UIView!
    @IBOutlet var tv_search_ex: UILabel!
    
    @IBOutlet var edt_search: MyTextField!
    @IBOutlet var btn_search_delete: UIButton!
    @IBOutlet var tl_search: UITableView!
    
    @IBOutlet var ad_view: AdView!
    @IBOutlet var ad_view_height: NSLayoutConstraint!
    
    var navMainView = NavMainView()
    var hoSlideMenu = HoSlideMenu()
    
    var locationManager = CLLocationManager()
    
    var isKeyboardShow = false
    
    var keywordList: [KaKaoKeyword] = []
    
    var isMyPositionMove = true // 내위치기준으로 맵중심이동여부
    var isFirstOnCreate = true // onCreate 체크 (내위치기준으로 맵중심을 이동할지 확인하기위해)
    var isMinTime = true // 3초 단위로 내 위치 체크
    
    // finishedMapMoveAnimation 가 두번불리는현상때문에 중복방지용
    var isRefresh = false // 처음 로딩인지 체크
    var lastLatitude: Double = 0 // 마지막 중심 latitude
    var lastLongitude: Double = 0 // 마지막 중심 longitude
    
    var interstitialAd: GADInterstitialAd?
    let adRemovalKey = "coupang_click_time"
    
    var toilet: Toilet = Toilet()
    var toiletList: [Int : Toilet] = [Int : Toilet]()
    
    var kakaoMap: KakaoMap?
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear: Bool = false
    var my_position: Poi! = nil
    var my_position_rotation: Float = 0
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewResizerOnKeyboardShown()
        
        LogManager.e(MyUtil.screenWidth)
        
        mapController = KMController(viewContainer: map_view!)
        mapController?.delegate = self
        mapController?.prepareEngine()
        
        let toolbarMarginTop = UIApplication.shared.statusBarFrame.height + 12
        btn_menu_marginTop.constant = toolbarMarginTop
        layout_my_position_marginTop.constant = toolbarMarginTop
        
        tv_my_position.text = "home_text_08".localized
        tv_search_ex.text = "home_text_09".localized
        edt_search.textColor = colors.text_main
        edt_search.setHint(hint: "home_text_01".localized, color: colors.main_hint)
        edt_search.delegate = self
        
        tl_search.register(UINib(nibName: "KakaoKeywordCell", bundle: nil), forCellReuseIdentifier: "KakaoKeywordCell")
        tl_search.dataSource = self
        tl_search.delegate = self
        
        hoSlideMenu.setMenuView(navMainView, dimen.home_menu_width, true)
        view.addSubview(hoSlideMenu)
        
        
        let animation = LottieAnimation.named("btn_me")
        lottie_my_position.animation = animation
        lottie_my_position.contentMode = .scaleAspectFit
        lottie_my_position.loopMode = .loop
        lottie_my_position.isUserInteractionEnabled = false
        setMyPosition(isHidden: true)
        
        loadAdMobInterstitial()
        
        ad_view.loadBannerAd()
        
        _init()
        setListener()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
        if (!isViewDidAppear) {
            isViewDidAppear = true
            refresh()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()  //렌더링 중지.
    }

    override func viewDidDisappear(_ animated: Bool) {
        isViewDidAppear = false
        removeObservers()
        //mapController?.resetEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    func _init() {
        checkPopup()
    }
    
    func refresh() {
        isRefresh = true
        navMainView.refresh()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            //mLocationManager.startUpdatingHeading()
        }
        
        if (SharedManager.instance.getReviewCount() == ToiletController.REVIEW_COUNT) {
            SharedManager.instance.setReviewCount(value: SharedManager.instance.getReviewCount() + 1)
            MyUtil.startInAppReview()
        }
    }
    
    func setListener() {
        layout_bottom_bg.setOnClickListener {
            self.edt_search.resignFirstResponder()
        }
        btn_search_delete.setOnClickListener {
            self.edt_search.text = ""
            self.tl_search.setVisibility(gone: true, dimen: 0, attribute: .height)
        }
        edt_search.addTextChangedListener {
            if (self.edt_search.text!.isEmpty) {
                self.tl_search.setVisibility(gone: true, dimen: 0, attribute: .height)
            } else {
                if (MyUtil.screenHeight < 600) {
                    self.tl_search.setVisibility(gone: false, dimen: 120, attribute: .height)
                } else {
                    self.tl_search.setVisibility(gone: false, dimen: 240, attribute: .height)
                }
                self.taskKakaoLocalSearch(query: self.edt_search.text!)
            }
        }
        layout_my_position.setOnClickListener {
            if (self.kakaoMap != nil) {
                if (SharedManager.instance.getLatitude() > 0) {
                    self.isMyPositionMove = true
                    self.kakaoMap!.moveCamera(CameraUpdate.make(target: MapPoint(longitude: SharedManager.instance.getLongitude(), latitude: SharedManager.instance.getLatitude()), zoomLevel: ObserverManager.BASE_ZOOM_LEVEL, rotation: 0, tilt: 0, mapView: self.kakaoMap!))
                    self.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
                    self.setMyPosition(isHidden: false)
                }
            }
        }
        btn_menu.setOnClickListener {
            self.hoSlideMenu.showMenu()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (keywordList.count > 0) {
            setKakaoLocal(kaKoKeyword: keywordList[0])
        }
        return true
    }
    
    override func keyboardWillShowForResizing(notification: Notification) {
        if (UIApplication.shared.applicationState != .active) {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
            isKeyboardShow = true
            layout_bottom_bg.isHidden = false
        }
    }
    
    override func keyboardWillHideForResizing(notification: Notification) {
        if (UIApplication.shared.applicationState != .active || self.view.frame.height == MyUtil.screenHeight) {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
            isKeyboardShow = false
            layout_bottom_bg.isHidden = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let azimuth = newHeading.trueHeading
        UIView.animate(withDuration: 0.3) {
            self.my_position_rotation = Float(azimuth)
            if (self.my_position != nil) {
                self.my_position.rotateAt(Double(self.my_position_rotation), duration: 0)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let newLocation: CLLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let oldLocation: CLLocation = CLLocation(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
        let distance = newLocation.distance(from: oldLocation)
        
        // 업데이트 거리기준 추가
        if (distance < 5) {
            return
        }
        
        // 업데이트 시간기준 추가
        // if (!mIsMinTime) {
        //     return
        // }
        // DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //     self.mIsMinTime = true
        // }
        
        SharedManager.instance.setLatitude(value: locValue.latitude)
        SharedManager.instance.setLongitude(value: locValue.longitude)
        
        if (kakaoMap != nil) {
            if (NSStringFromClass(ObserverManager.root.classForCoder) == NSStringFromClass(HomeController().classForCoder)
                && (isMyPositionMove && SharedManager.instance.getLatitude() > 0)) {
                kakaoMap!.moveCamera(CameraUpdate.make(cameraPosition: CameraPosition(target: MapPoint(longitude: SharedManager.instance.getLongitude(), latitude: SharedManager.instance.getLatitude()), height: 0, rotation: 0, tilt: 0)))
                self.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
                self.setMyPosition(isHidden: false)
                isMinTime = false
            }
        }
    }
    
    func cameraWillMove(kakaoMap: KakaoMap, by: MoveBy) {
        isMyPositionMove = false
        setMyPosition(isHidden: true)
    }
    
    func cameraDidStopped(kakaoMap: KakaoMap, by: MoveBy) {
        let position = kakaoMap.getPosition(CGPoint(x: map_view.frame.width * 0.5, y: map_view.frame.height * 0.5))
        if (isRefresh) {
            isRefresh = false
            setToliets(latitude: position.wgsCoord.latitude, longitude: position.wgsCoord.longitude)
        } else if (lastLatitude != position.wgsCoord.latitude || lastLongitude != position.wgsCoord.longitude) {
            setToliets(latitude: position.wgsCoord.latitude, longitude: position.wgsCoord.longitude)
        }
        if (String(format: "%.3f", position.wgsCoord.latitude) == String(format: "%.3f", SharedManager.instance.getLatitude()) && String(format: "%.3f", position.wgsCoord.longitude) == String(format: "%.3f", SharedManager.instance.getLongitude())) {
            setMyPosition(isHidden: false)
        } else {
            setMyPosition(isHidden: true)
        }
    }
    
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        LogManager.e(poiID)
        if (layerID != "toilet") {
            return
        }
        if (Int(poiID)! > 0) {
            tl_search.setVisibility(gone: true, dimen: 0, attribute: .height)
            
            let toilet = SQLiteManager.instance.getToilet(id: Int(poiID)!)
            let dialog = ToiletDialog(onDetail: { it in
                self.toilet = it
                if (!self.isAdRemoved()) {
                    self.showAdRemovalPopup() // 광고 제거 유도 팝업 띄우기
                } else {
                    self.openToiletDetail() // 광고 제거된 경우 바로 상세보기로 이동
                }
//                if (self.interstitialAd != nil) {
//                    self.interstitialAd?.present(fromRootViewController: self)
//                } else {
//                    let controller = ObserverManager.getController(name: "ToiletController")
//                    controller.segueData.putExtra(key: ToiletController.TOILET, data: self.toilet)
//                    ObserverManager.root.startPresent(controller: controller)
//                }
            })
            dialog.setToilet(toilet: toilet)
            dialog.refresh()
            dialog.show(view: ObserverManager.root.view)
        } else if (Int(poiID)! < 0) {
            if let toilet = toiletList[Int(poiID)!] {
                let dialog = ToiletDialog(onDetail: { it in
                    self.toilet = it
                    if (self.interstitialAd != nil) {
                        self.interstitialAd?.present(fromRootViewController: self)
                    } else {
                        let controller = ObserverManager.getController(name: "ToiletController")
                        controller.segueData.putExtra(key: ToiletController.TOILET, data: self.toilet)
                        ObserverManager.root.startPresent(controller: controller)
                    }
                })
                dialog.setToilet(toilet: toilet)
                dialog.refresh()
                dialog.show(view: ObserverManager.root.view)
            }
        }
    }
    
    func showAdRemovalPopup() {
        let dialog = BasicDialog(
            onLeftButton: {
                self.showAdMobInterstitial()
        },
            onRightButton: {
                self.openCoupangAd()
        })
        dialog.setTextContent("home_text_29".localized)
        dialog.setBtnLeft("home_text_30".localized)
        dialog.setBtnRight("home_text_31".localized)
        dialog.show(view: ObserverManager.root.view)
    }

    func loadAdMobInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "interstitial_ad_unit_id".localized, request: request) { ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error)")
                return
            }
            self.interstitialAd = ad
        }
    }

    func showAdMobInterstitial() {
        guard let interstitial = interstitialAd else {
            openToiletDetail()
            return
        }

        interstitialAd?.fullScreenContentDelegate = self
        interstitialAd?.present(fromRootViewController: self)
    }

    func openToiletDetail() {
        let controller = ObserverManager.getController(name: "ToiletController")
        controller.segueData.putExtra(key: ToiletController.TOILET, data: self.toilet)
        ObserverManager.root.startPresent(controller: controller)
    }

    func openCoupangAd() {
        if let url = URL(string: "https://link.coupang.com/a/cspD9C") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }

        // Save current timestamp to UserDefaults
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: adRemovalKey)
    }

    func isAdRemoved() -> Bool {
        let lastClick = UserDefaults.standard.double(forKey: adRemovalKey)
        let now = Date().timeIntervalSince1970
        return now < lastClick + 24 * 60 * 60
    }
    
    func checkPopup() {
        if (SharedManager.instance.getNoticeImage().count > 0) {
            let dialog = PopupDialog()
            dialog.show(view: ObserverManager.root.view)
        }
    }
    
    func setMyPosition(isHidden: Bool) {
        lottie_my_position.isHidden = isHidden
        if (lottie_my_position.isHidden == true) {
            lottie_my_position.stop()
        } else {
            lottie_my_position.play()
        }
    }
    
    func setToliets(latitude: Double, longitude: Double) {
        if (kakaoMap != nil) {
            lastLatitude = latitude
            lastLongitude = longitude

            for poi in kakaoMap!.getLabelManager().getLabelLayer(layerID: "toilet")!.getAllPois()! {
                kakaoMap!.getLabelManager().getLabelLayer(layerID: "toilet")?.removePoi(poiID: poi.itemID)
            }
            let toiletList = SQLiteManager.instance.getToiletList(latitude: lastLatitude, longitude: lastLongitude)
            for toilet in toiletList {
                addPOIItem(toilet: toilet)
            }
            taskToiletList(lastLatitude, lastLongitude)
            
            if (SharedManager.instance.getLatitude() > 0) {
                self.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
            }
        }
    }
    
    func setKakaoLocal(kaKoKeyword: KaKaoKeyword) {
        isMyPositionMove = false
        edt_search.text = kaKoKeyword.place_name
        kakaoMap!.moveCamera(CameraUpdate.make(target: MapPoint(longitude: kaKoKeyword.longitude, latitude: kaKoKeyword.latitude), zoomLevel: ObserverManager.BASE_ZOOM_LEVEL, rotation: 0, tilt: 0, mapView: self.kakaoMap!))
        edt_search.resignFirstResponder()
        tl_search.setVisibility(gone: true, dimen: 0, attribute: .height)
        setMyPosition(isHidden: true)
    }
    
    func addPOIItem(toilet: Toilet) {
        if (kakaoMap != nil) {
            if (toilet.toilet_id < 0) {
                let image = UIImage(named: "ic_position_up")!.imageResize(sizeChange: CGSize(width: 11.2, height: 12.8))
                
                let iconStyle = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1))
                let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
                let poiStyle = PoiStyle(styleID: "toilet_up", styles: [perLevelStyle])
                kakaoMap!.getLabelManager().addPoiStyle(poiStyle)
                
                let poiOption = PoiOptions(styleID: "toilet_up", poiID: String(toilet.toilet_id))
                poiOption.rank = 0
                poiOption.clickable = true
                let poi = kakaoMap!.getLabelManager().getLabelLayer(layerID: "toilet")?.addPoi(option: poiOption, at: MapPoint(longitude: toilet.longitude, latitude: toilet.latitude))
                poi?.show()
            } else {
                let image = UIImage(named: "ic_position")!.imageResize(sizeChange: CGSize(width: 11.2, height: 12.8))
                
                let iconStyle = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1))
                let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
                let poiStyle = PoiStyle(styleID: "toilet", styles: [perLevelStyle])
                kakaoMap!.getLabelManager().addPoiStyle(poiStyle)
                
                let poiOption = PoiOptions(styleID: "toilet", poiID: String(toilet.toilet_id))
                poiOption.rank = 0
                poiOption.clickable = true
                let poi = kakaoMap!.getLabelManager().getLabelLayer(layerID: "toilet")?.addPoi(option: poiOption, at: MapPoint(longitude: toilet.longitude, latitude: toilet.latitude))
                poi?.show()
            }
        }
    }
    
    func addMyPosition(latitude: Double, longitude: Double) {
        if (kakaoMap != nil) {
            let imageMe = UIImage(named: "ic_marker")!.imageResize(sizeChange: CGSize(width: 24, height: 24))
            if (my_position != nil) {
                kakaoMap!.getLabelManager().getLabelLayer(layerID: "toilet")?.removePoi(poiID: my_position.itemID)
            }
            
            let iconStyle = PoiIconStyle(symbol: imageMe, anchorPoint: CGPoint(x: 0.5, y: 0.5))
            let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
            let poiStyle = PoiStyle(styleID: "my_position", styles: [perLevelStyle])
            kakaoMap!.getLabelManager().addPoiStyle(poiStyle)
            
            let poiOption = PoiOptions(styleID: "my_position", poiID: "-1")
            poiOption.rank = 0
            poiOption.clickable = true
            my_position = kakaoMap!.getLabelManager().getLabelLayer(layerID: "toilet")?.addPoi(option: poiOption, at: MapPoint(longitude: longitude, latitude: latitude))
            my_position.show()
            LogManager.e("center_me : \(latitude) : \(longitude) : ")
        }
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
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        var defaultPosition = MapPoint(longitude: 127.108678, latitude: 37.402001)
        if (SharedManager.instance.getLatitude() > 0) {
            defaultPosition = MapPoint(longitude: SharedManager.instance.getLongitude(), latitude: SharedManager.instance.getLatitude())
        }
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: ObserverManager.BASE_ZOOM_LEVEL)
        
        //KakaoMap 추가.
        mapController?.addView(mapviewInfo)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        })
    }

    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        kakaoMap = mapController?.getView("mapview") as? KakaoMap
        if (kakaoMap != nil) {
            kakaoMap?.eventDelegate = self
            
            let _ = kakaoMap!.getLabelManager().addLabelLayer(option: LabelLayerOptions(layerID: "toilet", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001))
            
            // 현재위치기준으로 중심점 변경
            if (isFirstOnCreate) {
                isFirstOnCreate = false
                DispatchQueue.main.async {
                    if (SharedManager.instance.getLatitude() > 0) {
                        self.kakaoMap!.moveCamera(CameraUpdate.make(target: MapPoint(longitude: SharedManager.instance.getLongitude(), latitude: SharedManager.instance.getLatitude()), zoomLevel: ObserverManager.BASE_ZOOM_LEVEL, rotation: 0, tilt: 0, mapView: self.kakaoMap!))
                        self.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
                        self.setMyPosition(isHidden: false)
                    }
                }
            } else {
                let position = kakaoMap!.getPosition(CGPoint(x: self.map_view.frame.width * 0.5, y: map_view.frame.height * 0.5))
                if (lastLatitude == 0) {
                    lastLatitude = position.wgsCoord.latitude
                    lastLongitude = position.wgsCoord.longitude
                }
                kakaoMap!.moveCamera(CameraUpdate.make(target: MapPoint(longitude: lastLongitude, latitude: lastLatitude), zoomLevel: ObserverManager.BASE_ZOOM_LEVEL, rotation: 0, tilt: 0, mapView: kakaoMap!))
            }
        }
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
    
    /**
     * [GET] 화장실목록
     */
    func taskToiletList(_ latitude: Double, _ longitude: Double) {
        var params: Parameters = Parameters()
        params.put("latitude", latitude)
        params.put("longitude", longitude)
        
        BaseTask().request(url: NetDefine.TOILET_LIST, method: .get, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
                    let jsonArray = it.getJSONArray("toilets")
                    self.toiletList = [Int:Toilet]()

                    for i in 0 ..< jsonArray.count {
                        let jsonObject = jsonArray.getJSONObject(i)
                        let toilet = Toilet()
                        toilet.toilet_id = jsonObject.getInt("toilet_id")
                        toilet.member_id = jsonObject.getString("member_id")
                        toilet.type = "유저"
                        toilet.m_name = jsonObject.getString("m_name")
                        toilet.name = jsonObject.getString("name")
                        toilet.content = jsonObject.getString("content")
                        toilet.address_new = jsonObject.getString("address_new")
                        toilet.address_old = jsonObject.getString("address_old")
                        if (jsonObject.getInt("unisex") == 1) {
                            toilet.unisex = "Y"
                        } else {
                            toilet.unisex = "N"
                        }
                        toilet.m_poo = jsonObject.getString("man")
                        toilet.w_poo = jsonObject.getString("woman")
                        toilet.latitude = jsonObject.getDouble("latitude")
                        toilet.longitude = jsonObject.getDouble("longitude")
                        self.toiletList[toilet.toilet_id] = toilet
                        self.addPOIItem(toilet: toilet)
                    }
                }
        }
            , onFailed: { statusCode in
                
        })
    }

    /**
     * [GET] 카카오지도 키워드 검색
     */
    func taskKakaoLocalSearch(query: String) {
        var params: Parameters = Parameters()
        params.put("query", query) // 검색을 원하는 질의어
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK " + NetDefine.KAKAO_API_KEY,
        ]
        
        BaseTask().request(url: NetDefine.KAKAO_LOCAL_SEARCH, method: .post, params: params, headers: headers, fullUrl: true
            , onSuccess: { response in
                self.keywordList = []
                let jsonArray = response.getJSONArray("documents")

                for i in 0 ..< jsonArray.count {
                    let jsonObject = jsonArray.getJSONObject(i)
                    let keyword = KaKaoKeyword()
                    keyword.address_name = jsonObject.getString("address_name")
                    keyword.place_name = jsonObject.getString("place_name")
                    keyword.latitude = jsonObject.getDouble("y")
                    keyword.longitude = jsonObject.getDouble("x")

                    self.keywordList.append(keyword)
                }

                self.tl_search.reloadData()
        }
            , onFailed: { statusCode in
                
        })
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource, GADFullScreenContentDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoKeywordCell")! as! KakaoKeywordCell
        let position = indexPath.row
        
        cell.tv_title.text = keywordList[position].place_name
        cell.tv_sub.text = keywordList[position].address_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position = indexPath.row
        setKakaoLocal(kaKoKeyword: keywordList[position])
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        let controller = ObserverManager.getController(name: "ToiletController")
        controller.segueData.putExtra(key: ToiletController.TOILET, data: self.toilet)
        ObserverManager.root.startPresent(controller: controller)
        
        interstitialAd = nil
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        let controller = ObserverManager.getController(name: "ToiletController")
        controller.segueData.putExtra(key: ToiletController.TOILET, data: self.toilet)
        ObserverManager.root.startPresent(controller: controller)
        
        interstitialAd = nil
    }
    
}
