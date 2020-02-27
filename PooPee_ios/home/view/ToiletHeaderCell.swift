//
//  ToiletHeaderView.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/10/28.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit

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
    
    @IBOutlet var layout_ad_mob: UIView!
    
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

        cb_tap_address.setSelected(selected: true)
        layout_detail_address.setVisibility(gone: false, dimen: 0, attribute: .height)
        cb_tap_manager.setSelected(selected: false)
        layout_detail_manager.setVisibility(gone: true, dimen: 0, attribute: .height)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
