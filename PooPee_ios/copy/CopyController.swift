//
//  CopyController.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 8..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit
import Alamofire

class CopyController: BaseController {
    
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
