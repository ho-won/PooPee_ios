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

class HomeController: BaseController, MTMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var map_view: UIView!
    
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
    
    var mMapView: MTMapView!
    var mLocationManager = CLLocationManager()
    
    let mImageMaker = UIImage(named: "ic_position")!
    var mIsKeyboardShow = false
    
    var mKeywordList: [KaKaoKeyword] = []
    
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
        
        _init()
        setListener()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refresh()
    }
    
    func _init() {
        if (CLLocationManager.locationServicesEnabled()) {
            mLocationManager = CLLocationManager()
            mLocationManager.delegate = self
            mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            mLocationManager.requestAlwaysAuthorization()
            mLocationManager.startUpdatingLocation()
        }
        
        mMapView = MTMapView(frame: map_view.bounds)
        
        mMapView.delegate = self
        mMapView.baseMapType = .standard
        map_view.addSubview(mMapView)
        
        if (SharedManager.instance.getLatitude() > 0) {
            mMapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: true)
        }
        
        checkPopup()
    }
    
    func refresh() {
        mNavMainView.refresh()
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
                self.mMapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: true)
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
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        
        let latitude = mapCenterPoint.mapPointGeo().latitude
        let longitude = mapCenterPoint.mapPointGeo().longitude
        
        mMapView.removeAllPOIItems()
        let toiletList = SQLiteManager.instance.getToiletList(latitude: latitude, longitude: longitude)
        for toilet in toiletList {
            self.addPOIItem(toilet: toilet, latitude: toilet.latitude, longitude: toilet.longitude)
        }
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        let toilet = SQLiteManager.instance.getToilet(id: poiItem.tag)
        let dialog = ToiletDialog()
        print("HO_TEST:\(toilet.toilet_id)")
        dialog.setToilet(toilet: toilet)
        dialog.refresh()
        dialog.show(view: ObserverManager.root.view)
        return false
    }
    
    func addPOIItem(toilet: Toilet, latitude: Double, longitude: Double) {
        let marker = MTMapPOIItem()
        marker.itemName = toilet.name
        marker.tag = toilet.toilet_id
        marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
        marker.markerType = MTMapPOIItemMarkerType.customImage // 마커타입을 커스텀 마커로 지정.
        marker.customImage = mImageMaker // 마커 이미지.
        marker.markerSelectedType = MTMapPOIItemMarkerSelectedType.customImage // 마커를 클릭했을때, 기본으로 제공하는 RedPin 마커 모양.
        marker.customSelectedImage = mImageMaker
        marker.customImageAnchorPointOffset = MTMapImageOffset(offsetX: 30, offsetY: 0)
        mMapView.add(marker)
        
    }
    
    func checkPopup() {
        if (SharedManager.instance.getNoticeImage().count > 0) {
            let dialog = PopupDialog()
            dialog.show(view: ObserverManager.root.view)
        }
    }

    /**
     * [GET] 카카오지도 키워드 검색
     */
    func taskKakaoLocalSearch(query: String) {
        var params: Parameters = Parameters()
        params.updateValue(query, forKey: "query") // 검색을 원하는 질의어
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK " + NetDefine.KAKAO_API_KEY,
        ]
        
        BaseTask().requestPostFullUrl(url: NetDefine.KAKAO_LOCAL_SEARCH, params: params, headers: headers
            , onSuccess: { response in
                self.mKeywordList = []
                let jsonArray = response.getJSONArray(key: "documents")

                for i in 0 ..< jsonArray.count {
                    let jsonObject = jsonArray.getJSONObject(index: i)
                    let keyword = KaKaoKeyword()
                    keyword.address_name = jsonObject.getString(key: "address_name")
                    keyword.place_name = jsonObject.getString(key: "place_name")
                    keyword.latitude = jsonObject.getDouble(key: "y")
                    keyword.longitude = jsonObject.getDouble(key: "x")

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
        
        edt_search.text = mKeywordList[position].place_name

        mMapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: mKeywordList[position].latitude, longitude: mKeywordList[position].longitude)), animated: true)
        edt_search.resignFirstResponder()
        tl_search.setVisibility(gone: true, dimen: 0, attribute: .height)
    }
    
}
