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

class ToiletCreateController: BaseController, CLLocationManagerDelegate {
    static let KAKAO_KEYWORD = "KaKaoKeyword"
    
    @IBOutlet var tv_toolbar_title: UIButton!
    
    @IBOutlet var map_view: UIView!
    
    @IBOutlet var layout_ex: UIView!
    @IBOutlet var tv_ex: UILabel!
    
    @IBOutlet var btn_my_position: UIButton!
    @IBOutlet var btn_bottom: UIButton!
    
    var mLocationManager = CLLocationManager()
    
    var mKeyword: KaKaoKeyword? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        
        layout_ex.layer.cornerRadius = 14
        
        tv_toolbar_title.setTitle("toilet_create_text_03".localized, for: .normal)
        tv_ex.text = "toilet_create_text_04".localized
        btn_bottom.setTitle("toilet_create_text_05".localized, for: .normal)
        
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
        
        ObserverManager.mapView = MTMapView(frame: map_view.bounds)
        ObserverManager.mapView.setZoomLevel(3, animated: true)
        ObserverManager.mapView.baseMapType = .standard
        map_view.addSubview(ObserverManager.mapView)

        if (mKeyword != nil) {
            // 카카오검색기준으로 중심점변경
            ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: mKeyword!.latitude, longitude: mKeyword!.longitude)), animated: false)
        } else if (SharedManager.instance.getLatitude() > 0) {
            // 현재위치기준으로 중심점변경
            ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: false)
        }
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        btn_my_position.setOnClickListener {
            if (SharedManager.instance.getLatitude() > 0) {
                ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: SharedManager.instance.getLatitude(), longitude: SharedManager.instance.getLongitude())), animated: false)
                ObserverManager.mapView.setZoomLevel(3, animated: true)
            }
        }
        btn_bottom.setOnClickListener {
            let dialog = ToiletCreateDialog(
                ObserverManager.mapView.mapCenterPoint.mapPointGeo().latitude,
                ObserverManager.mapView.mapCenterPoint.mapPointGeo().longitude,
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
    
    @IBAction func onBackPressed(_ sender: Any) {
        for subview in map_view.subviews {
            subview.removeFromSuperview()
        }
        finish()
    }
    
}
