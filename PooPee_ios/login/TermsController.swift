//
//  TermsController.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/10/25.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import WebKit

class TermsController: BaseController {
    static let ACTION_TERMS_01 = "ACTION_TERMS_01" // 개인정보 처리방침
    static let ACTION_TERMS_02 = "ACTION_TERMS_02" // 서비스 이용약관
    static let ACTION_TERMS_03 = "ACTION_TERMS_03" // 위치정보기반 서비스 이용약관
    
    @IBOutlet var root_view: UIView!
    @IBOutlet var web_view: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        
        web_view.scrollView.bounces = false
        
        _init()
        setListener()
    }
    
    func _init() {
        let action = segueData.action
        
        LogManager.e(action)
        if (action == TermsController.ACTION_TERMS_01) {
            web_view.load(URLRequest(url: URL(string: NetDefine.BASE_APP + NetDefine.TERMS_01)!))
        } else if (action == TermsController.ACTION_TERMS_02) {
            web_view.load(URLRequest(url: URL(string: NetDefine.BASE_APP + NetDefine.TERMS_02)!))
        } else if (action == TermsController.ACTION_TERMS_03) {
            web_view.load(URLRequest(url: URL(string: NetDefine.BASE_APP + NetDefine.TERMS_03)!))
        }
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}
