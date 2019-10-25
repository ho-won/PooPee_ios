//
//  ToiletController.swift
//  PooPee_ios
//
//  Created by ho1 on 08/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire

class ToiletController: BaseController {
    static let TOILET = "toilet"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.primary)
        
        _init()
        setListener()
    }
    
    func _init() {
        _ = view.layer.observe(\.bounds) { object, _ in
            print(object.bounds)
        }
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
        params.put("", "")
        
        BaseTask().request(url: NetDefine.TEST_API, method: .post, params: params
            , onSuccess: { response in
                
        }
            , onFailed: { statusCode in
                
        })
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}
