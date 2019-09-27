//
//  CopyCustomView.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 9..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

class CopyCustomView: UIView {
    @IBOutlet var root_view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onCreate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onCreate()
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("CopyCustomView", owner: self, options: nil)
        addSubview(root_view)
        root_view.frame = self.bounds
        root_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
