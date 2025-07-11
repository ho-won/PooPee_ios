//
//  MyInfoController.swift
//  PooPee_ios
//
//  Created by ho1 on 07/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire

class MyInfoController: BaseController {
    @IBOutlet var root_view: UIView!
    
    @IBOutlet var tv_toolbar_title: UIButton!
    @IBOutlet var btn_update: UIButton!
    
    @IBOutlet var edt_name: base_edt!
    @IBOutlet var rb_man: cb_gender_man!
    @IBOutlet var rb_woman: cb_gender_woman!
    
    @IBOutlet var edt_password: base_edt!
    @IBOutlet var edt_password_confirm: base_edt!
    @IBOutlet var iv_password_ex: UIImageView!
    @IBOutlet var tv_password_ex: UILabel!
    
    @IBOutlet var ad_view: AdView!
    @IBOutlet var ad_view_height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        setupViewResizerOnKeyboardShown()
        hideKeyboardWhenTappedAround()
        
        tv_toolbar_title.setTitle("nav_text_01".localized, for: .normal)
        btn_update.setTitle("modified".localized, for: .normal)
        
        edt_name.setHint(hint: "login_09".localized, color: UIColor(hex: "#d0d2d5")!)
        rb_man.setTitle("man".localized, for: .normal)
        rb_woman.setTitle("women".localized, for: .normal)
        
        edt_password.setHint(hint: "login_05".localized, color: UIColor(hex: "#d0d2d5")!)
        edt_password_confirm.setHint(hint: "login_06".localized, color: UIColor(hex: "#d0d2d5")!)
        iv_password_ex.image = UIImage(named: "ic_alret")
        tv_password_ex.text = "login_14".localized
        
        ad_view.loadBannerAd()
        
        _init()
        setListener()
    }
    
    func _init() {
        edt_password.setPattern(pattern: .alphanumeric)
        edt_password.maxLength = 20
        edt_password_confirm.setPattern(pattern: .alphanumeric)
        edt_password_confirm.maxLength = 20
        edt_name.setPattern(pattern: .alphanumeric_hangul)
        edt_name.maxLength = 20

        edt_name.text = SharedManager.memberName
        
        if (SharedManager.memberGender == "0") {
            rb_man.setSelected(selected: true)
        } else {
            rb_woman.setSelected(selected: true)
        }
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        rb_man.setOnClickListener {
            self.rb_man.setSelected(selected: true)
            self.rb_woman.setSelected(selected: false)
        }
        rb_woman.setOnClickListener {
            self.rb_man.setSelected(selected: false)
            self.rb_woman.setSelected(selected: true)
        }
        edt_password.addTextChangedListener {
            if (self.edt_password.text! != self.edt_password_confirm.text!) {
                self.tv_password_ex.text = "toast_join_condition_01".localized
                self.tv_password_ex.textColor = UIColor(hex: "#ff4a5c")
                self.iv_password_ex.image = UIImage(named: "ic_alret_error")
            } else {
                self.tv_password_ex.text = "login_14".localized
                self.tv_password_ex.textColor = UIColor(hex: "#d0d2d5")
                self.iv_password_ex.image = UIImage(named: "ic_alret")
            }
        }
        edt_password_confirm.addTextChangedListener {
            if (self.edt_password.text! != self.edt_password_confirm.text!) {
                self.tv_password_ex.text = "toast_join_condition_01".localized
                self.tv_password_ex.textColor = UIColor(hex: "#ff4a5c")
                self.iv_password_ex.image = UIImage(named: "ic_alret_error")
            } else {
                self.tv_password_ex.text = "login_14".localized
                self.tv_password_ex.textColor = UIColor(hex: "#d0d2d5")
                self.iv_password_ex.image = UIImage(named: "ic_alret")
            }
        }
        btn_update.setOnClickListener {
            if (self.edt_name.text!.isEmpty) {
                self.view.makeToast(message: "toast_please_name_input".localized)
            } else if (self.edt_password.text != self.edt_password_confirm.text) {
                self.view.makeToast(message: "toast_join_condition_01".localized)
            } else if (!self.rb_man.isSelected && !self.rb_woman.isSelected) {
                self.view.makeToast(message: "toast_join_condition_02".localized)
            } else {
                if (self.rb_man.isSelected) {
                    self.taskUpdateUser(password: self.edt_password.text!, name: self.edt_name.text!, gender: "0")
                } else {
                    self.taskUpdateUser(password: self.edt_password.text!, name: self.edt_name.text!, gender: "1")
                }
            }
        }
    }

    /**
     * [PUT] 회원정보수정
     */
    func taskUpdateUser(password: String, name: String, gender: String) {
        showLoading()
        var params: Parameters = Parameters()
        params.put("member_id", SharedManager.memberId)

        var pw = SharedManager.memberPassword
        if (!password.isEmpty) {
            pw = password
        }
        params.put("password", pw)

        params.put("name", name)
        params.put("gender", gender)
        
        BaseTask().request(url: NetDefine.USER_UPDATE, method: .put, params: params
            , onSuccess: { it in
            if (it.getInt("rst_code") == 0) {
                SharedManager.memberPassword = pw
                SharedManager.memberName = name
                SharedManager.memberGender = gender
                self.getParentController().view.makeToast(message: "toast_update_complete".localized)
                self.finish()
            }
            self.hideLoading()
        }
            , onFailed: { statusCode in
            self.hideLoading()
        })
    }

    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}
