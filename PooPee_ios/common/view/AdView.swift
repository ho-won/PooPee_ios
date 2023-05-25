//
//  AdView.swift
//  PooPee_ios
//
//  Created by ho1 on 2020/10/15.
//  Copyright © 2020 ho1. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdView: GADBannerView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    func _init() {
        self.backgroundColor = .white
        adSize = GADAdSizeBanner
        adUnitID = "banner_ad_unit_id".localized
        rootViewController = ObserverManager.root
        load(GADRequest())
    }
    
}
