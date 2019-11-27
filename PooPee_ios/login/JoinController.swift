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
    
    @IBOutlet var ic_id_ex: UIImageView!
    @IBOutlet var tv_id_ex: UILabel!
    
    
    
    
    
    @IBOutlet var ic_password_ex: UIImageView!
    @IBOutlet var tv_password_ex: UILabel!
    
    
    
    @IBOutlet var layout_back: UIView!
    @IBOutlet var tv_back: UILabel!
    @IBOutlet var layout_join: UIView!
    @IBOutlet var tv_join: UILabel!
    @IBOutlet var iv_join: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        setupViewResizerOnKeyboardShown()
        hideKeyboardWhenTappedAround()
        
        tv_title.text = "login_04".localized
        edt_name.setHint(hint: "login_09".localized, color: UIColor(hex: "#d0d2d5")!)
        rb_man.setTitle("man".localized, for: .normal)
        rb_woman.setTitle("women".localized, for: .normal)
        
        tv_back.text = "prev".localized
        tv_join.text = "complete".localized
        
        _init()
        setListener()
    }
    
    func _init() {
        edt_name.setPattern(pattern: .alphanumeric_hangul)
        edt_name.maxLength = 20
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
        
        layout_back.setOnClickListener {
            self.finish()
        }
        layout_join.setOnClickListener {
            
        }
    }
    
    /**
     * [POST]
     */
    func task() {
        var params: Parameters = Parameters()
        params.put("", "")
        
        BaseTask().request(url: NetDefine.TEST_API, method: .post, params: params
            , onSuccess: { response in
                
        }
            , onFailed: { statusCode in
                
        })
    }
    
}
