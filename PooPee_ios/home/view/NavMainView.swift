//
//  NavMainView.swift
//  PooPee_ios
//
//  Created by ho1 on 07/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import MessageUI

class NavMainView: UIView, MFMailComposeViewControllerDelegate {
    @IBOutlet var root_view: UIView!
    @IBOutlet var layout_content_marginTop: NSLayoutConstraint!
    
    @IBOutlet var layout_login: UIView!
    @IBOutlet var iv_login: UIImageView!
    @IBOutlet var tv_name: UILabel!
    
    @IBOutlet var layout_toilet_create: UIView!
    @IBOutlet var tv_toilet_create: UILabel!
    
    @IBOutlet var layout_my_info: UIView!
    @IBOutlet var tv_my_info: UILabel!
    
    @IBOutlet var layout_notice: UIView!
    @IBOutlet var tv_notice: UILabel!
    
    @IBOutlet var layout_request: UIView!
    @IBOutlet var tv_request: UILabel!
    
    @IBOutlet var layout_app_install: UIView!
    @IBOutlet var tv_app_install: UILabel!
    
    @IBOutlet var layout_setting: UIView!
    @IBOutlet var tv_setting: UILabel!
    
    @IBOutlet var layout_donate: UIView!
    @IBOutlet var tv_donate: UILabel!
    
    @IBOutlet var btn_logout: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    func _init() {
        Bundle.main.loadNibNamed("NavMainView", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        root_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        layout_content_marginTop.constant = UIApplication.shared.statusBarFrame.height
        
        tv_toilet_create.text = "nav_text_07".localized
        tv_my_info.text = "nav_text_01".localized
        tv_notice.text = "nav_text_02".localized
        tv_request.text = "nav_text_03".localized
        tv_setting.text = "nav_text_04".localized
        tv_app_install.text = "nav_text_08".localized
        tv_donate.text = "nav_text_09".localized
        
        refresh()
        setListener()
    }
    
    func setView() {
        
    }
    
    func refresh() {
        if (SharedManager.isLoginCheck) {
            tv_name.text = SharedManager.memberName
            iv_login.image = UIImage(named: "img_profile")
            btn_logout.setImage(UIImage(named: "ic_logout"), for: .normal)
        } else {
            let str = "nav_text_06".localized
            tv_name.attributedText = MyUtil.attributedText(withString: str, font: tv_name.font, lineString: [str])
            iv_login.image = UIImage(named: "img_logingo")
            btn_logout.setImage(UIImage(named: "img_menu_bottom"), for: .normal)
        }
    }
    
    func setListener() {
        layout_login.setOnClickListener {
            if (!SharedManager.isLoginCheck) {
                let controller = ObserverManager.getController(name: "LoginController")
                ObserverManager.root.startPresent(controller: controller)
            }
        }
        layout_toilet_create.setOnClickListener {
            if (SharedManager.isLoginCheck) {
                let controller = ObserverManager.getController(name: "ToiletSearchController")
                ObserverManager.root.startPresent(controller: controller)
            } else {
                let controller = ObserverManager.getController(name: "LoginController")
                ObserverManager.root.startPresent(controller: controller)
            }
        }
        layout_my_info.setOnClickListener {
            if (SharedManager.isLoginCheck) {
                let controller = ObserverManager.getController(name: "MyInfoController")
                ObserverManager.root.startPresent(controller: controller)
            } else {
                let controller = ObserverManager.getController(name: "LoginController")
                ObserverManager.root.startPresent(controller: controller)
            }
        }
        layout_notice.setOnClickListener {
            let controller = ObserverManager.getController(name: "NoticeController")
            ObserverManager.root.startPresent(controller: controller)
        }
        layout_request.setOnClickListener {
            self.sendEmail()
        }
        layout_app_install.setOnClickListener {
            MyUtil.shareText(NetDefine.BASE_APP + NetDefine.APP_INSTALL)
        }
        layout_setting.setOnClickListener {
            let controller = ObserverManager.getController(name: "SettingController")
            ObserverManager.root.startPresent(controller: controller)
        }
        layout_donate.setOnClickListener {
            let controller = ObserverManager.getController(name: "DonateController")
            ObserverManager.root.startPresent(controller: controller)
        }
        btn_logout.setOnClickListener {
            if (SharedManager.isLoginCheck) {
                ObserverManager.logout()
                self.refresh()
            }
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["seohwjjang@gmail.com"])
            mail.setSubject("nav_text_05".localized)
            // mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            ObserverManager.root.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
