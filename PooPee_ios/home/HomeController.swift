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
    @IBOutlet var layout_my_position: bg_my_position!
    @IBOutlet var tv_my_position: UILabel!
    
    @IBOutlet var layout_bottom_bg: UIView!
    @IBOutlet var tv_search_ex: UILabel!
    
    @IBOutlet var edt_search: MyTextField!
    @IBOutlet var btn_search_delete: UIButton!
    @IBOutlet var tl_search: UITableView!
    
    @IBOutlet var layout_ad_mob: UIView!
    
    var mMapView: MTMapView!
    var mLocationManager = CLLocationManager()
    
    let mImageMaker = UIImage(named: "ic_position")!
    var mIsKeyboardShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        hideKeyboardWhenTappedAround()
        setupViewResizerOnKeyboardShown()
        
        tv_my_position.text = "home_text_08".localized
        tv_search_ex.text = "home_text_09".localized
        edt_search.textColor = colors.text_main
        edt_search.setHint(hint: "home_text_01".localized, color: colors.main_hint)
        
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
        
    }
    
    func setListener() {
        layout_my_position.setOnClickListener {
            if (SharedManager.instance.getLatitude() > 0) {
                self.mMapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: true)
            }
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
            
        }
    }
    
    
    /**
     * [POST]
     */
    func task() {
        var params: Parameters = Parameters()
        params.updateValue("", forKey: "")
        
        BaseTask().requestPost(url: NetDefine.TEST_API, params: params
            , onSuccess: { response in
                
        }
            , onFailed: { statusCode in
                
        })
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        
    }
    
    
    //    private func setListener() {
    //        root_view.setOnClickListener {
    //            MyUtil.keyboardHide(edt_search)
    //        }
    //        btn_search_delete.setOnClickListener {
    //            edt_search.setText("")
    //            MyUtil.keyboardHide(edt_search)
    //            rv_search.visibility = View.GONE
    //        }
    //        edt_search.setOnTouchListener { _, _ ->
    //            edt_search.requestFocus()
    //            MyUtil.keyboardShow(edt_search)
    //            rv_search.visibility = View.VISIBLE
    //            true
    //        }
    //        edt_search.addTextChangedListener(object : TextWatcher {
    //            func afterTextChanged(p0: Editable?) {
    //
    //            }
    //
    //            func beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
    //
    //            }
    //
    //            func onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
    //                taskKakaoLocalSearch(p0.toString())
    //            }
    //        })
    //    }
    //
    //    func onMapViewDoubleTapped(p0: MapView?, p1: MapPoint?) {
    //    }
    //
    //    func onMapViewInitialized(p0: MapView?) {
    //    }
    //
    //    func onMapViewDragStarted(p0: MapView?, p1: MapPoint?) {
    //    }
    //
    //    func onMapViewCenterPointMoved(p0: MapView?, p1: MapPoint?) {
    //    }
    //
    //    func onMapViewDragEnded(p0: MapView?, p1: MapPoint?) {
    //    }
    //
    //    func onMapViewSingleTapped(p0: MapView?, p1: MapPoint?) {
    //    }
    //
    //    func onMapViewZoomLevelChanged(p0: MapView?, p1: Int) {
    //    }
    //
    //    func onMapViewLongPressed(p0: MapView?, p1: MapPoint?) {
    //    }
    //
    //    func onCalloutBalloonOfPOIItemTouched(p0: MapView?, p1: MapPOIItem?) {
    //    }
    //
    //    func onCalloutBalloonOfPOIItemTouched(p0: MapView?, p1: MapPOIItem?, p2: MapPOIItem.CalloutBalloonButtonType?) {
    //    }
    //
    //    func onDraggablePOIItemMoved(p0: MapView?, p1: MapPOIItem?, p2: MapPoint?) {
    //    }
    //
    //    /**
    //     * 카카오지도 아이템 클릭
    //     */
    //    func onPOIItemSelected(p0: MapView?, p1: MapPOIItem?) {
    //        val toilet = Toilet()
    //        toilet.toilet_id = p1!!.tag
    //        toilet.name = p1.itemName
    //
    //        val dialog = ToiletDialog()
    //        dialog.setToilet(toilet)
    //        dialog.show(supportFragmentManager, "ToiletDialog")
    //    }
    //
    //
    //    private func checkPopup() {
    //        if (SharedManager.getNoticeImage().count() > 0) {
    //            val dialog = PopupDialog()
    //            dialog.show(supportFragmentManager, "PopupDialog")
    //        }
    //    }
    //
    //    /**
    //     * [GET] 카카오지도 키워드 검색
    //     */
    //    private func taskKakaoLocalSearch(query: String) {
    //        val params = RetrofitParams()
    //        params.put("query", query) // 검색을 원하는 질의어
    //
    //        val request = RetrofitClient.getClientKaKao(RetrofitService.KAKAO_LOCAL).create(RetrofitService::class.java).kakaoLocalSearch(params.getParams())
    //
    //        RetrofitJSONObject(request,
    //        onSuccess = {
    //        try {
    //        mKeywordList = ArrayList()
    //        val jsonArray = it.getJSONArray("documents")
    //
    //        for (i in 0 until jsonArray.length()) {
    //        val jsonObject = jsonArray.getJSONObject(i)
    //        val keyword = KaKaoKeyword()
    //        keyword.address_name = jsonObject.getString("address_name")
    //        keyword.place_name = jsonObject.getString("place_name")
    //        keyword.latitude = jsonObject.getDouble("y")
    //        keyword.longitude = jsonObject.getDouble("x")
    //
    //        mKeywordList.add(keyword)
    //        }
    //
    //        mKeywordAdapter.notifyDataSetChanged()
    //        } catch (e: JSONException) {
    //        e.printStackTrace()
    //        }
    //        },
    //        onFailed = {
    //
    //        }
    //        )
    //    }
    
}

///**
// * 공지사항 목록 adapter
// */
//class ListAdapter : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
//
//    func onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
//        return ViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_kakao_keyword, parent, false))
//    }
//
//    func onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
//        (holder as ViewHolder).update(position)
//    }
//
//    func getItemCount(): Int {
//        return mKeywordList.size
//    }
//
//    func getItemViewType(position: Int): Int {
//        return 0
//    }
//
//    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
//
//        @SuppressLint("SetTextI18n")
//        func update(position: Int) {
//            val sizeString: Array<String> = arrayOf(" (" + mKeywordList[position].address_name + ")")
//            val colorString: Array<String> = arrayOf(" (" + mKeywordList[position].address_name + ")")
//
//            val span = MySpannableString(mKeywordList[position].place_name + " (" + mKeywordList[position].address_name + ")")
//            span.setSize(sizeString, 12)
//            span.setColor(colorString, "#999999")
//            itemView.tv_title.text = span.getSpannableString()
//
//            itemView.layout_title.setOnClickListener {
//                mMapView.setMapCenterPoint(MapPoint.mapPointWithGeoCoord(mKeywordList[position].latitude, mKeywordList[position].longitude), true)
//                MyUtil.keyboardHide(edt_search)
//                rv_search.visibility = View.GONE
//            }
//        }
//    }
//}
