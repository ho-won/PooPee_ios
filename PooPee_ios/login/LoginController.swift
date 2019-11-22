//
//  LoginController.swift
//  PooPee_ios
//
//  Created by ho1 on 07/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire

class LoginController: BaseController {
    @IBOutlet var btn_close: UIButton!
    
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var edt_username: MyTextField!
    @IBOutlet var edt_password: MyTextField!
    
    @IBOutlet var layout_join: UIView!
    @IBOutlet var tv_join: UILabel!
    @IBOutlet var btn_login: bg_login!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewResizerOnKeyboardShown()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = colors.login_background
        
        tv_title.text = "login_01".localized
        edt_username.setHint(hint: "login_02".localized, color: UIColor(hex: "#85b3ff")!)
        edt_password.setHint(hint: "login_03".localized, color: UIColor(hex: "#85b3ff")!)
        
        edt_username.setPattern(pattern: .alphanumeric)
        
        tv_join.text = "login_04".localized
        btn_login.setTitle("login".localized, for: .normal)
        
        _init()
        setListener()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func _init() {
        
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        btn_login.setOnClickListener {
            if (self.edt_username.text!.isEmpty || self.edt_password.text!.isEmpty) {
                self.view.makeToast(message: "toast_login_condition".localized)
            } else {
                self.taskLogin(username: self.edt_username.text!, password: self.edt_password.text!)
            }
        }
        layout_join.setOnClickListener {
            let controller = ObserverManager.getController(name: "JoinController")
            self.startPresent(controller: controller)
        }
        edt_username.addTextChangedListener {
            self.checkIdPw()
        }
        edt_password.addTextChangedListener {
            self.checkIdPw()
        }
    }
    
    func checkIdPw() {
        btn_login.setEnabled(enable: !edt_username.text!.isEmpty && !edt_password.text!.isEmpty)
    }
    
    /**
     * [POST] 로그인
     */
    func taskLogin(username: String, password: String) {
        showLoading()
        var params: Parameters = Parameters()
        params.put("username", username)
        params.put("password", password)
        params.put("pushkey", "test")
        params.put("os", "ios")
        
        BaseTask().request(url: NetDefine.LOGIN, method: .post, params: params
            , onSuccess: { response in
                if (response.getInt("rst_code") == 0) {
                    SharedManager.instance.setLoginCheck(value: true)
                    SharedManager.instance.setMemberId(value: response.getString("member_id"))
                    SharedManager.instance.setMemberUsername(value: username)
                    SharedManager.instance.setMemberPassword(value: password)
                    SharedManager.instance.setMemberName(value: response.getString("name"))
                    SharedManager.instance.setMemberGender(value: response.getString("gender"))
                    self.finish()
                } else {
                    self.view.makeToast(message: "toast_login_fail".localized)
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
