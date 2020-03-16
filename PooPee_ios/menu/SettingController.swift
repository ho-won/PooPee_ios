//
//  SettingController.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/10/25.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire

class SettingController: BaseController {
    @IBOutlet var root_view: UIView!
    
    @IBOutlet var tv_toolbar_title: UIButton!
    
    @IBOutlet var layout_login: UIView!
    @IBOutlet var iv_login: UIImageView!
    @IBOutlet var tv_login: UILabel!
    @IBOutlet var tv_logout: UILabel!
    @IBOutlet var layout_push: UIView!
    @IBOutlet var tv_push: UILabel!
    @IBOutlet var switch_push: switch_push!
    @IBOutlet var layout_terms_01: UIView!
    @IBOutlet var tv_terms_01: UILabel!
    @IBOutlet var layout_terms_02: UIView!
    @IBOutlet var tv_terms_02: UILabel!
    @IBOutlet var layout_terms_03: UIView!
    @IBOutlet var tv_terms_03: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        
        tv_toolbar_title.setTitle("nav_text_04".localized, for: .normal)
        
        tv_logout.text = "menu_setting_02".localized
        tv_push.text = "menu_setting_03".localized
        tv_terms_01.text = "menu_setting_04".localized
        tv_terms_02.text = "menu_setting_05".localized
        tv_terms_03.text = "menu_setting_06".localized
        
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
    }
    
    func _init() {
        
    }
    
    func refresh() {
        if (SharedManager.instance.isLoginCheck()) {
            tv_login.text = SharedManager.instance.getMemberName()
            tv_logout.isHidden = false
            if (SharedManager.instance.getMemberGender() == "0") {
                iv_login.image = UIImage(named: "ic_man_profile")
            } else {
                iv_login.image = UIImage(named: "ic_woman_profile")
            }
        } else {
            tv_login.text = "menu_setting_01".localized
            tv_logout.isHidden = true

            iv_login.image = UIImage(named: "ic_profile")
        }
        switch_push.isOn = SharedManager.instance.isPush()
    }
    
    func setListener() {
        layout_login.setOnClickListener {
            if (SharedManager.instance.isLoginCheck()) {
                ObserverManager.logout()
                self.refresh()
            } else {
                let controller = ObserverManager.getController(name: "LoginController")
                ObserverManager.root.startPresent(controller: controller)
            }
        }
        switch_push.setOnCheckedChangedListener {
            SharedManager.instance.setPush(value: self.switch_push.isOn)
        }
        layout_terms_01.setOnClickListener {
            let controller = ObserverManager.getController(name: "TermsController")
            controller.segueData.action = TermsController.ACTION_TERMS_01
            ObserverManager.root.startPresent(controller: controller)
        }
        layout_terms_02.setOnClickListener {
            let controller = ObserverManager.getController(name: "TermsController")
            controller.segueData.action = TermsController.ACTION_TERMS_02
            ObserverManager.root.startPresent(controller: controller)
        }
        layout_terms_03.setOnClickListener {
            if (SharedManager.instance.getMemberUsername() == "master") {
                let controller = ObserverManager.getController(name: "MaskController")
                ObserverManager.root.startPresent(controller: controller)
            } else {
                let controller = ObserverManager.getController(name: "TermsController")
                controller.segueData.action = TermsController.ACTION_TERMS_03
                ObserverManager.root.startPresent(controller: controller)
            }
        }
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}
