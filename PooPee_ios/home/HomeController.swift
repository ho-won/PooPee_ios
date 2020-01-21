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

class HomeController: BaseController, MTMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var map_view: UIView!
    @IBOutlet var lottie_my_position: AnimationView!
    
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
    
    @IBOutlet var layout_ad_mob: UIView!
    
    var mNavMainView = NavMainView()
    var mHoSlideMenu = HoSlideMenu()
    
    var mLocationManager = CLLocationManager()
    
    var mIsKeyboardShow = false
    
    var mKeywordList: [KaKaoKeyword] = []
    
    var mIsMyPositionMove = true // 내위치기준으로 맵중심이동여부
    var mIsFirstOnCreate = true // onCreate 체크 (내위치기준으로 맵중심을 이동할지 확인하기위해)
    
    // finishedMapMoveAnimation 가 두번불리는현상때문에 중복방지용
    var mLastLatitude: Double = 0 // 마지막 중심 latitude
    var mLastLongitude: Double = 0 // 마지막 중심 longitude
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewResizerOnKeyboardShown()
        
        let toolbarMarginTop = UIApplication.shared.statusBarFrame.height + 12
        btn_menu_marginTop.constant = toolbarMarginTop
        layout_my_position_marginTop.constant = toolbarMarginTop
        
        tv_my_position.text = "home_text_08".localized
        tv_search_ex.text = "home_text_09".localized
        edt_search.textColor = colors.text_main
        edt_search.setHint(hint: "home_text_01".localized, color: colors.main_hint)
        
        tl_search.register(UINib(nibName: "KakaoKeywordCell", bundle: nil), forCellReuseIdentifier: "KakaoKeywordCell")
        tl_search.dataSource = self
        tl_search.delegate = self
        
        mHoSlideMenu.setMenuView(menu_view: mNavMainView, menu_width: dimen.home_menu_width)
        view.addSubview(mHoSlideMenu)
        
        
        let animation = Animation.named("btn_me")
        lottie_my_position.animation = animation
        lottie_my_position.contentMode = .scaleAspectFit
        lottie_my_position.loopMode = .loop
        setMyPosition(isHidden: true)
        
        _init()
        setListener()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        if (!isViewDidAppear) {
            print("HomeController_viewDidAppear")
            isViewDidAppear = true
            refresh()
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        print("HomeController_viewDidDisappear")
        isViewDidAppear = false
        for subview in map_view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func _init() {
        checkPopup()
    }
    
    func refresh() {
        mNavMainView.refresh()
        if (CLLocationManager.locationServicesEnabled()) {
            mLocationManager = CLLocationManager()
            mLocationManager.delegate = self
            mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            mLocationManager.requestAlwaysAuthorization()
            mLocationManager.startUpdatingLocation()
        }
        
        ObserverManager.mapView = MTMapView(frame: map_view.bounds)
        ObserverManager.mapView.setZoomLevel(2, animated: true)
        
        ObserverManager.mapView.delegate = self
        ObserverManager.mapView.baseMapType = .standard
        map_view.addSubview(ObserverManager.mapView)
        
        // 현재위치기준으로 중심점 변경
        if (mIsFirstOnCreate) {
            mIsFirstOnCreate = false
            DispatchQueue.main.async {
                if (SharedManager.instance.getLatitude() > 0) {
                    ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: false)
                    ObserverManager.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
                    self.setMyPosition(isHidden: false)
                }
            }
        } else {
            if (mLastLatitude == 0) {
                mLastLatitude = ObserverManager.mapView.mapCenterPoint.mapPointGeo().latitude
                mLastLongitude = ObserverManager.mapView.mapCenterPoint.mapPointGeo().longitude
            }
            ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: mLastLatitude, longitude: mLastLongitude)), animated: false)
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
                self.tl_search.setVisibility(gone: false, dimen: 240, attribute: .height)
                self.taskKakaoLocalSearch(query: self.edt_search.text!)
            }
        }
        layout_my_position.setOnClickListener {
            if (SharedManager.instance.getLatitude() > 0) {
                self.mIsMyPositionMove = true
                ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: false)
                ObserverManager.mapView.setZoomLevel(2, animated: false)
                ObserverManager.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
                self.setMyPosition(isHidden: false)
            }
        }
        btn_menu.setOnClickListener {
            self.mHoSlideMenu.showMenu()
        }
    }
    
    override func setupViewResizerOnKeyboardShown() {
        super.setupViewResizerOnKeyboardShown()
    }
    
    override func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
            self.view.layoutIfNeeded()
            mIsKeyboardShow = true
            layout_bottom_bg.isHidden = false
        }
    }
    
    override func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
            self.view.layoutIfNeeded()
            mIsKeyboardShow = false
            layout_bottom_bg.isHidden = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        SharedManager.instance.setLatitude(value: locValue.latitude)
        SharedManager.instance.setLongitude(value: locValue.longitude)
        
        if (mIsMyPositionMove && SharedManager.instance.getLatitude() > 0) {
            ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: false)
            ObserverManager.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
            self.setMyPosition(isHidden: false)
        }
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        if (mLastLatitude != mapCenterPoint.mapPointGeo().latitude
            && mLastLongitude != mapCenterPoint.mapPointGeo().longitude) {
            mLastLatitude = mapCenterPoint.mapPointGeo().latitude
            mLastLongitude = mapCenterPoint.mapPointGeo().longitude

            ObserverManager.mapView.removeAllPOIItems()
            let toiletList = SQLiteManager.instance.getToiletList(latitude: mLastLatitude, longitude: mLastLongitude)
            for toilet in toiletList {
                ObserverManager.addPOIItem(toilet: toilet)
            }
            if (SharedManager.instance.getLatitude() > 0) {
                ObserverManager.addMyPosition(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())
            }
        }
    }
    
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        mIsMyPositionMove = false
        setMyPosition(isHidden: true)
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        if (poiItem.tag > 0) {
            let toilet = SQLiteManager.instance.getToilet(id: poiItem.tag)
            let dialog = ToiletDialog()
            print("HO_TEST:\(toilet.toilet_id)")
            dialog.setToilet(toilet: toilet)
            dialog.refresh()
            dialog.show(view: ObserverManager.root.view)
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
                self.mKeywordList = []
                let jsonArray = response.getJSONArray("documents")

                for i in 0 ..< jsonArray.count {
                    let jsonObject = jsonArray.getJSONObject(i)
                    let keyword = KaKaoKeyword()
                    keyword.address_name = jsonObject.getString("address_name")
                    keyword.place_name = jsonObject.getString("place_name")
                    keyword.latitude = jsonObject.getDouble("y")
                    keyword.longitude = jsonObject.getDouble("x")

                    self.mKeywordList.append(keyword)
                }

                self.tl_search.reloadData()
        }
            , onFailed: { statusCode in
                
        })
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mKeywordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoKeywordCell")! as! KakaoKeywordCell
        let position = indexPath.row
        
        cell.tv_title.text = mKeywordList[position].place_name
        cell.tv_sub.text = mKeywordList[position].address_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position = indexPath.row
        
        mIsMyPositionMove = false
        edt_search.text = mKeywordList[position].place_name

        ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: mKeywordList[position].latitude, longitude: mKeywordList[position].longitude)), animated: true)
        edt_search.resignFirstResponder()
        tl_search.setVisibility(gone: true, dimen: 0, attribute: .height)
        setMyPosition(isHidden: true)
    }
    
}
