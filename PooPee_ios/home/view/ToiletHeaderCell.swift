//
//  ToiletHeaderView.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/10/28.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ToiletHeaderCell: UITableViewCell {
    @IBOutlet var root_view: UIView!
    
    @IBOutlet var map_view: UIView!
    @IBOutlet var map_view_click: UIView!
    @IBOutlet var btn_like: btn_like!
    
    @IBOutlet var tv_address: UILabel!
    @IBOutlet var cb_tap_address: cb_up_down!
    
    @IBOutlet var cb_option_01: cb_option_01!
    @IBOutlet var cb_option_02: cb_option_02!
    @IBOutlet var cb_option_03: cb_option_03!
    @IBOutlet var cb_option_04: cb_option_04!
    @IBOutlet var cb_option_05: cb_option_05!
    @IBOutlet var cb_option_06: cb_option_06!
    
    @IBOutlet var layout_detail_icon: UIView!
    @IBOutlet var layout_detail_address: UIView!
    
    @IBOutlet var tv_m: UILabel!
    @IBOutlet var tv_m_poo_title: UILabel!
    @IBOutlet var tv_m_poo: UILabel!
    @IBOutlet var tv_m_pee_title: UILabel!
    @IBOutlet var tv_m_pee: UILabel!
    @IBOutlet var tv_m_d_poo_title: UILabel!
    @IBOutlet var tv_m_d_poo: UILabel!
    @IBOutlet var tv_m_d_pee_title: UILabel!
    @IBOutlet var tv_m_d_pee: UILabel!
    @IBOutlet var tv_m_c_poo_title: UILabel!
    @IBOutlet var tv_m_c_poo: UILabel!
    @IBOutlet var tv_m_c_pee_title: UILabel!
    @IBOutlet var tv_m_c_pee: UILabel!
    
    @IBOutlet var tv_w: UILabel!
    @IBOutlet var tv_w_poo_title: UILabel!
    @IBOutlet var tv_w_poo: UILabel!
    @IBOutlet var tv_w_d_poo_title: UILabel!
    @IBOutlet var tv_w_d_poo: UILabel!
    @IBOutlet var tv_w_c_poo_title: UILabel!
    @IBOutlet var tv_w_c_poo: UILabel!
    
    @IBOutlet var tv_manager: UILabel!
    @IBOutlet var cb_tap_manager: cb_up_down!
    
    @IBOutlet var layout_detail_manager: UIView!
    @IBOutlet var tv_manager_name_title: UILabel!
    @IBOutlet var tv_manager_name: UILabel!
    @IBOutlet var tv_manager_tel_title: UILabel!
    @IBOutlet var tv_manager_tel: UILabel!
    @IBOutlet var tv_open_time_title: UILabel!
    @IBOutlet var tv_open_time: UILabel!
    
    @IBOutlet var ad_view: GADBannerView!
    
    @IBOutlet var tv_comment: UILabel!
    @IBOutlet var tv_comment_count: UILabel!
    @IBOutlet var btn_comment: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ObserverManager.mapView = MTMapView(frame: map_view.bounds)
        ObserverManager.mapView.setZoomLevel(2, animated: true)
        
        ObserverManager.mapView.baseMapType = .standard
        map_view.addSubview(ObserverManager.mapView)
        
        tv_m.text = "toilet_option_01".localized
        tv_m_poo_title.text = "toilet_option_03".localized
        tv_m_pee_title.text = "toilet_option_04".localized
        tv_m_d_poo_title.text = "toilet_option_05".localized
        tv_m_d_pee_title.text = "toilet_option_06".localized
        tv_m_c_poo_title.text = "toilet_option_07".localized
        tv_m_c_pee_title.text = "toilet_option_08".localized
        
        tv_w.text = "toilet_option_02".localized
        tv_w_poo_title.text = "toilet_option_03".localized
        tv_w_d_poo_title.text = "toilet_option_05".localized
        tv_w_c_poo_title.text = "toilet_option_07".localized
        
        tv_manager.text = "home_text_10".localized
        tv_manager_name_title.text = "toilet_option_10".localized
        tv_manager_tel_title.text = "toilet_option_11".localized
        tv_open_time_title.text = "toilet_option_12".localized
        
        tv_comment.text = "home_text_03".localized
        
        ad_view.adSize = kGADAdSizeBanner
        ad_view.adUnitID = "banner_ad_unit_id".localized
        ad_view.rootViewController = ObserverManager.root
        ad_view.load(GADRequest())

        
        ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: ObserverManager.currentToilet.latitude, longitude: ObserverManager.currentToilet.longitude)), animated: true)
        ObserverManager.addPOIItem(toilet: ObserverManager.currentToilet)
        
        if (ObserverManager.currentToilet.type == "졸음쉼터" || ObserverManager.currentToilet.type == "휴게소") {
            cb_tap_address.isHidden = true
            cb_tap_address.setSelected(selected: false)
            cb_tap_manager.setSelected(selected: true)
            layout_detail_icon.setVisibility(gone: true, dimen: 0, attribute: .height)
            layout_detail_address.setVisibility(gone: true, dimen: 0, attribute: .height)
            layout_detail_manager.setVisibility(gone: false, dimen: 0, attribute: .height)
        } else {
            cb_tap_address.isHidden = false
            cb_tap_address.setSelected(selected: true)
            cb_tap_manager.setSelected(selected: false)
            layout_detail_icon.setVisibility(gone: false, dimen: 64, attribute: .height)
            layout_detail_address.setVisibility(gone: false, dimen: 0, attribute: .height)
            layout_detail_manager.setVisibility(gone: true, dimen: 0, attribute: .height)
        }
        
        var addressText: String
        if (ObserverManager.currentToilet.address_new.count > 0) {
            addressText = ObserverManager.currentToilet.address_new
        } else {
            addressText = ObserverManager.currentToilet.address_old
        }
        StrManager.setAddressCopySpan(tv_address: tv_address, addressText: addressText)
        
        // 남녀공용
        cb_option_01.setSelected(selected: ObserverManager.currentToilet.unisex == "Y")
        
        // 남자화장실
        let option02Count = (Int(ObserverManager.currentToilet.m_poo) ?? 0) + (Int(ObserverManager.currentToilet.m_pee) ?? 0)
        cb_option_02.setSelected(selected: option02Count > 0)
        
        // 여자화장실
        let option03Count = (Int(ObserverManager.currentToilet.w_poo) ?? 0)
        cb_option_03.setSelected(selected: option03Count > 0)
        
        // 장애인화장실
        let option04Count = (Int(ObserverManager.currentToilet.m_d_poo) ?? 0) + (Int(ObserverManager.currentToilet.m_d_pee) ?? 0) + (Int(ObserverManager.currentToilet.w_d_poo) ?? 0)
        cb_option_04.setSelected(selected: option04Count > 0)
        
        // 남자어린이화장실
        let option05Count = (Int(ObserverManager.currentToilet.m_c_poo) ?? 0) + (Int(ObserverManager.currentToilet.m_c_pee) ?? 0)
        cb_option_05.setSelected(selected: option05Count > 0)
        
        // 여자어린이화장실
        let option06Count = (Int(ObserverManager.currentToilet.w_c_poo) ?? 0)
        cb_option_06.setSelected(selected: option06Count > 0)
        
        tv_m_poo.text = ObserverManager.currentToilet.m_poo
        tv_m_pee.text = ObserverManager.currentToilet.m_pee
        tv_m_d_poo.text = ObserverManager.currentToilet.m_d_poo
        tv_m_d_pee.text = ObserverManager.currentToilet.m_d_pee
        tv_m_c_poo.text = ObserverManager.currentToilet.m_c_poo
        tv_m_c_pee.text = ObserverManager.currentToilet.m_c_pee
        
        tv_w_poo.text = ObserverManager.currentToilet.w_poo
        tv_w_d_poo.text = ObserverManager.currentToilet.w_d_poo
        tv_w_c_poo.text = ObserverManager.currentToilet.w_c_poo
        
        tv_manager_name.text = ObserverManager.currentToilet.manager_name
        tv_manager_tel.text = ObserverManager.currentToilet.manager_tel
        tv_open_time.text = ObserverManager.currentToilet.open_time
        
        tv_comment_count.text = ObserverManager.currentToilet.comment_count
        btn_like.setSelected(selected: ObserverManager.currentToilet.like_check)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
