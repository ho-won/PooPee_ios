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

class HomeController: BaseController, MTMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, GADFullScreenContentDelegate {
    
    @IBOutlet var map_view: UIView!
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
    
    var toilet: Toilet = Toilet()
    var toiletList: [Int : Toilet] = [Int : Toilet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewResizerOnKeyboardShown()
        
        LogManager.e(MyUtil.screenWidth)
        
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
        
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: "interstitial_ad_unit_id".localized,
            request: request,
            completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitialAd = ad
                interstitialAd?.fullScreenContentDelegate = self
            })
        
        ad_view.loadBannerAd()
        
        _init()
        setListener()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        if (!isViewDidAppear) {
            isViewDidAppear = true
            refresh()
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        isViewDidAppear = false
        for subview in map_view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func _init() {
        checkPopup()
    }
    
    func refresh() {
        isRefresh = true
        navMainView.refresh()
        
        ObserverManager.mapView = MTMapView(frame: map_view.bounds)
        ObserverManager.mapView.setZoomLevel(3, animated: true)
        
        ObserverManager.mapView.delegate = self
        ObserverManager.mapView.baseMapType = .standard
        map_view.addSubview(ObserverManager.mapView)
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            //mLocationManager.startUpdatingHeading()
        }
        
        // 현재위치기준으로 중심점 변경
        if (isFirstOnCreate) {
            isFirstOnCreate = false
            DispatchQueue.main.async {
                if (SharedManager.instance.getLatitude() > 0) {
                    ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: false)
                    ObserverManager.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
                    self.setMyPosition(isHidden: false)
                }
            }
        } else {
            if (lastLatitude == 0) {
                lastLatitude = ObserverManager.mapView.mapCenterPoint.mapPointGeo().latitude
                lastLongitude = ObserverManager.mapView.mapCenterPoint.mapPointGeo().longitude
            }
            ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: lastLatitude, longitude: lastLongitude)), animated: false)
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
            if (SharedManager.instance.getLatitude() > 0) {
                self.isMyPositionMove = true
                ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: false)
                ObserverManager.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
                self.setMyPosition(isHidden: false)
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        let azimuth = newHeading.trueHeading
//        UIView.animate(withDuration: 0.3) {
//            ObserverManager.my_position_rotation = Float(azimuth)
//            if (ObserverManager.my_position != nil) {
//                ObserverManager.my_position.rotation = ObserverManager.my_position_rotation
//            }
//        }
//    }
    
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
        
        if (NSStringFromClass(ObserverManager.root.classForCoder) == NSStringFromClass(HomeController().classForCoder)
            && (isMyPositionMove && SharedManager.instance.getLatitude() > 0)) {
            ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: false)
            ObserverManager.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
            self.setMyPosition(isHidden: false)
            isMinTime = false
        }
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        if (NSStringFromClass(ObserverManager.root.classForCoder) == NSStringFromClass(HomeController().classForCoder)) {
            if (isRefresh) {
                isRefresh = false
                setToliets(latitude: mapCenterPoint.mapPointGeo().latitude, longitude: mapCenterPoint.mapPointGeo().longitude)
            } else if (lastLatitude != mapCenterPoint.mapPointGeo().latitude || lastLongitude != mapCenterPoint.mapPointGeo().longitude) {
                setToliets(latitude: mapCenterPoint.mapPointGeo().latitude, longitude: mapCenterPoint.mapPointGeo().longitude)
            }
        }
    }
    
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        isMyPositionMove = false
        setMyPosition(isHidden: true)
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        if (poiItem.tag > 0) {
            tl_search.setVisibility(gone: true, dimen: 0, attribute: .height)
            
            let toilet = SQLiteManager.instance.getToilet(id: poiItem.tag)
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
        } else if (poiItem.tag < 0) {
            if let toilet = toiletList[poiItem.tag] {
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
        return false
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
        lastLatitude = latitude
        lastLongitude = longitude

        ObserverManager.mapView.removeAllPOIItems()
        let toiletList = SQLiteManager.instance.getToiletList(latitude: lastLatitude, longitude: lastLongitude)
        for toilet in toiletList {
            ObserverManager.addPOIItem(toilet: toilet)
        }
        taskToiletList(lastLatitude, lastLongitude)
        
        if (SharedManager.instance.getLatitude() > 0) {
            ObserverManager.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
        }
    }
    
    func setKakaoLocal(kaKoKeyword: KaKaoKeyword) {
        isMyPositionMove = false
        edt_search.text = kaKoKeyword.place_name

        ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: kaKoKeyword.latitude, longitude: kaKoKeyword.longitude)), animated: true)
        edt_search.resignFirstResponder()
        tl_search.setVisibility(gone: true, dimen: 0, attribute: .height)
        setMyPosition(isHidden: true)
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
                        ObserverManager.addPOIItem(toilet: toilet)
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

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
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
    
}
