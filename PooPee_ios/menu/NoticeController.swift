//
//  NoticeController.swift
//  PooPee_ios
//
//  Created by ho1 on 07/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire

class NoticeController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.primary)
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        
    }
    
    /**
     * [POST]
     */
    func task() {
        var params: Parameters = Parameters()
        params.updateValue("", forKey: "")
        
        BaseTask().requestPost(url: NetDefine.TEST_API, params: params
            , onSuccess: { response in
                
        }
            , onFailed: { statusCode in
                
        })
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}
