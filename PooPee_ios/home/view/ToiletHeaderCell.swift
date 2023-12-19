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
    
    @IBOutlet var tv_toilet_name: MyLabel!
    @IBOutlet var tv_toilet_content: MyLabel!
    
    @IBOutlet var layout_btn_normal: UIView!
    @IBOutlet var layout_like: bg_layout_like!
    @IBOutlet var cb_like: btn_like!
    @IBOutlet var tv_like: UILabel!
    @IBOutlet var layout_report: bg_layout_like!
    @IBOutlet var tv_report: UILabel!
    
    @IBOutlet var layout_btn_mine: UIView!
    @IBOutlet var layout_delete: bg_layout_like!
    @IBOutlet var tv_delete: UILabel!
    @IBOutlet var layout_update: bg_layout_like!
    @IBOutlet var tv_update: UILabel!
    
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
    
    @IBOutlet var layout_detail_manager_title: UIView!
    @IBOutlet var layout_detail_manager: UIView!
    @IBOutlet var tv_manager_name_title: UILabel!
    @IBOutlet var tv_manager_name: UILabel!
    @IBOutlet var tv_manager_tel_title: UILabel!
    @IBOutlet var tv_manager_tel: UILabel!
    @IBOutlet var tv_open_time_title: UILabel!
    @IBOutlet var tv_open_time: UILabel!
    
    @IBOutlet var tv_comment: UILabel!
    @IBOutlet var tv_comment_count: UILabel!
    @IBOutlet var btn_comment: UIButton!
    
    @IBOutlet var ad_view: AdView!
    @IBOutlet var ad_view_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ObserverManager.mapView = MTMapView(frame: map_view.bounds)
        ObserverManager.mapView.setZoomLevel(2, animated: true)
        
        ObserverManager.mapView.baseMapType = .standard
        map_view.addSubview(ObserverManager.mapView)
        
        tv_like.text = "0"
        tv_report.text = "toilet_btn_01".localized
        tv_delete.text = "toilet_btn_02".localized
        tv_update.text = "toilet_btn_03".localized
        
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
        
        ad_view.loadBannerAd()
        
        ObserverManager.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: ObserverManager.currentToilet.latitude, longitude: ObserverManager.currentToilet.longitude)), animated: true)
        ObserverManager.addPOIItem(toilet: ObserverManager.currentToilet)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
