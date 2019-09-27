//
//  CopyView.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 8..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit
import Alamofire

class CopyView: UIView {
    @IBOutlet var root_view: UIView!
    
    var mListener: onCopyViewListener!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onCreate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onCreate()
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("CopyView", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        root_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        
    }
    
}

protocol onCopyViewListener {
}
