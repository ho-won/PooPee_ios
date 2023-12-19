//
//  JoinController.swift
//  PooPee_ios
//
//  Created by ho1 on 07/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire

class JoinController: BaseController {
    @IBOutlet var root_view: UIView!
    
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var edt_name: base_edt!
    @IBOutlet var rb_man: cb_gender_man!
    @IBOutlet var rb_woman: cb_gender_woman!
    
    @IBOutlet var edt_username: base_edt!
    @IBOutlet var tv_overlap: tv_overlap!
    @IBOutlet var iv_id_ex: UIImageView!
    @IBOutlet var tv_id_ex: UILabel!
    
    @IBOutlet var edt_password: base_edt!
    @IBOutlet var edt_password_confirm: base_edt!
    @IBOutlet var iv_password_ex: UIImageView!
    @IBOutlet var tv_password_ex: UILabel!
    
    @IBOutlet var cb_terms_01: cb_terms!
    @IBOutlet var tv_terms_01_detail: UILabel!
    @IBOutlet var cb_terms_02: cb_terms!
    @IBOutlet var tv_terms_02_detail: UILabel!
    @IBOutlet var cb_terms_03: cb_terms!
    @IBOutlet var tv_terms_03_detail: UILabel!
    
    @IBOutlet var layout_back: UIView!
    @IBOutlet var tv_back: UILabel!
    @IBOutlet var layout_join: UIView!
    @IBOutlet var tv_join: UILabel!
    @IBOutlet var iv_join: UIImageView!
    
    @IBOutlet var ad_view: AdView!
    @IBOutlet var ad_view_height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        setupViewResizerOnKeyboardShown()
        hideKeyboardWhenTappedAround()
        
        tv_title.text = "login_04".localized
        edt_name.setHint(hint: "login_09".localized, color: UIColor(hex: "#d0d2d5")!)
        rb_man.setTitle("man".localized, for: .normal)
        rb_woman.setTitle("women".localized, for: .normal)
        
        edt_username.setHint(hint: "login_02".localized, color: UIColor(hex: "#d0d2d5")!)
        tv_overlap.text = "login_10".localized
        tv_overlap.setEnabled(false)
        iv_id_ex.image = UIImage(named: "ic_alret")
        tv_id_ex.text = "login_11".localized
        
        edt_password.setHint(hint: "login_05".localized, color: UIColor(hex: "#d0d2d5")!)
        edt_password_confirm.setHint(hint: "login_06".localized, color: UIColor(hex: "#d0d2d5")!)
        iv_password_ex.image = UIImage(named: "ic_alret")
        tv_password_ex.text = "login_14".localized
        
        cb_terms_01.setTitle("login_15".localized, for: .normal)
        cb_terms_02.setTitle("login_16".localized, for: .normal)
        cb_terms_03.setTitle("login_17".localized, for: .normal)
        tv_terms_01_detail.text = "login_18".localized
        tv_terms_02_detail.text = "login_18".localized
        tv_terms_03_detail.text = "login_18".localized
        
        tv_back.text = "prev".localized
        tv_join.text = "complete".localized
        
        ad_view.loadBannerAd()
        
        _init()
        setListener()
    }
    
    func _init() {
        edt_username.setPattern(pattern: .alphanumeric)
        edt_username.maxLength = 20
        edt_password.setPattern(pattern: .alphanumeric)
        edt_password.maxLength = 20
        edt_password_confirm.setPattern(pattern: .alphanumeric)
        edt_password_confirm.maxLength = 20
        edt_name.setPattern(pattern: .alphanumeric_hangul)
        edt_name.maxLength = 20
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        edt_name.addTextChangedListener {
            self.checkAllInput()
        }
        rb_man.setOnClickListener {
            self.rb_man.setSelected(selected: true)
            self.rb_woman.setSelected(selected: false)
        }
        rb_woman.setOnClickListener {
            self.rb_man.setSelected(selected: false)
            self.rb_woman.setSelected(selected: true)
        }
        edt_username.addTextChangedListener {
            self.tv_id_ex.text = "login_11".localized
            self.tv_id_ex.textColor = UIColor(hex: "#d0d2d5")
            self.iv_id_ex.image = UIImage(named: "ic_alret")
            self.tv_overlap.setEnabled(self.edt_username.text!.count > 5)
            self.checkAllInput()
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
            self.checkAllInput()
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
            self.checkAllInput()
        }
        tv_overlap.setOnClickListener {
            if (self.edt_username.text!.count > 5) {
                self.taskOverlap(username: self.edt_username.text!)
            }
        }
        cb_terms_01.setOnClickListener {
            self.cb_terms_01.setSelected(selected: !self.cb_terms_01.isSelected)
            self.checkAllInput()
        }
        cb_terms_02.setOnClickListener {
            self.cb_terms_02.setSelected(selected: !self.cb_terms_02.isSelected)
            self.checkAllInput()
        }
        cb_terms_03.setOnClickListener {
            self.cb_terms_03.setSelected(selected: !self.cb_terms_03.isSelected)
            self.checkAllInput()
        }
        tv_terms_01_detail.setOnClickListener {
            let controller = ObserverManager.getController(name: "TermsController")
            controller.segueData.action = TermsController.ACTION_TERMS_01
            ObserverManager.root.startPresent(controller: controller)
        }
        tv_terms_02_detail.setOnClickListener {
            let controller = ObserverManager.getController(name: "TermsController")
            controller.segueData.action = TermsController.ACTION_TERMS_02
            ObserverManager.root.startPresent(controller: controller)
        }
        tv_terms_03_detail.setOnClickListener {
            let controller = ObserverManager.getController(name: "TermsController")
            controller.segueData.action = TermsController.ACTION_TERMS_03
            ObserverManager.root.startPresent(controller: controller)
        }
        layout_back.setOnClickListener {
            self.finish()
        }
        layout_join.setOnClickListener {
            if (self.edt_username.text!.isEmpty || self.edt_password.text!.isEmpty || self.edt_password_confirm.text!.isEmpty || self.edt_name.text!.isEmpty) {
                self.view.makeToast(message: "toast_please_all_input".localized)
            } else if (self.edt_password.text! != self.edt_password_confirm.text!) {
                self.view.makeToast(message: "toast_join_condition_01".localized)
            } else if (!self.rb_man.isSelected && !self.rb_woman.isSelected) {
                self.view.makeToast(message: "toast_join_condition_02".localized)
            } else if (!self.cb_terms_01.isSelected || !self.cb_terms_02.isSelected || !self.cb_terms_03.isSelected) {
                self.view.makeToast(message: "toast_terms_check".localized)
            } else {
                var gender = "1"
                if (self.rb_man.isSelected) {
                    gender = "0"
                }
                self.taskJoin(username: self.edt_username.text!, password: self.edt_password.text!, name: self.edt_name.text!, gender: gender)
            }
        }
    }

    func checkAllInput() {
        layout_join.isUserInteractionEnabled = false
        tv_join.textColor = UIColor(hex: "#6b9bff")
        iv_join.image = UIImage(named: "ic_join_nonext")

        if (edt_name.text!.isEmpty) {
            return
        }
        if (!rb_man.isSelected && !rb_woman.isSelected) {
            return
        }
        if (edt_username.text!.isEmpty || edt_username.text!.count < 6) {
            return
        }
        if (edt_password.text!.isEmpty || edt_password_confirm.text!.isEmpty) {
            return
        }
        if (edt_password.text! != edt_password_confirm.text!) {
            return
        }
        if (!cb_terms_01.isSelected || !cb_terms_02.isSelected || !cb_terms_03.isSelected) {
            return
        }

        layout_join.isUserInteractionEnabled = true
        tv_join.textColor = UIColor(hex: "#ffffff")
        iv_join.image = UIImage(named: "ic_join_next")
    }

    /**
     * [GET] 아이디 중복체크
     */
    func taskOverlap(username: String) {
        showLoading()
        var params: Parameters = Parameters()
        params.put("username", username)
        
        BaseTask().request(url: NetDefine.OVER_LAP, method: .get, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
                    self.tv_id_ex.text = "login_12".localized
                    self.tv_id_ex.textColor = UIColor(hex: "#2470ff")
                    self.iv_id_ex.image = UIImage(named: "ic_alret_check")
                } else if (it.getInt("rst_code") == 1) {
                    self.tv_id_ex.text = "toast_join_id_fail".localized
                    self.tv_id_ex.textColor = UIColor(hex: "#ff4a5c")
                    self.iv_id_ex.image = UIImage(named: "ic_alret_error")
                }
                self.hideLoading()
        }
            , onFailed: { statusCode in
                self.hideLoading()
        })
    }

    /**
     * [POST] 회원가입
     */
    func taskJoin(username: String, password: String, name: String, gender: String) {
        showLoading()
        var params: Parameters = Parameters()
        params.put("username", username)
        params.put("password", password)
        params.put("name", name)
        params.put("gender", gender)
        
        BaseTask().request(url: NetDefine.JOIN, method: .post, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
                    self.view.makeToast(message: "toast_join_complete".localized)
                    self.edt_username.resignFirstResponder()
                    self.finish()
                } else if (it.getInt("rst_code") == 1) {
                    self.view.makeToast(message: "toast_join_id_fail".localized)
                }
                self.hideLoading()
        }
            , onFailed: { statusCode in
                self.hideLoading()
        })
    }
    
}
