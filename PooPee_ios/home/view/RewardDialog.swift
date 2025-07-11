//
//  RewardDialog.swift
//  PooPee_ios
//
//  Created by ho1 on 7/4/25.
//  Copyright © 2025 ho1. All rights reserved.
//

import UIKit
import Alamofire

class RewardDialog: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var tv_title_sub: UILabel!
    
    @IBOutlet var btn_rewarded_ad: UIButton!
    @IBOutlet var btn_rewarded_interstitial_ad: UIButton!
    
    var onRewardedAd: ()->()
    var onRewardedInterstitialAd: ()->()
    
    init(onRewardedAd: @escaping ()->(), onRewardedInterstitialAd: @escaping ()->()){
        self.onRewardedAd = onRewardedAd
        self.onRewardedInterstitialAd = onRewardedInterstitialAd
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("RewardDialog", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        tv_title.text = "dialog_reward_01".localized
        tv_title_sub.text = "dialog_reward_02".localized
        btn_rewarded_ad.setTitle("dialog_reward_03".localized, for: .normal)
        btn_rewarded_interstitial_ad.setTitle("dialog_reward_04".localized, for: .normal)
        
        btn_rewarded_ad.backgroundColor = colors.primary
        btn_rewarded_ad.layer.cornerRadius = 10
        btn_rewarded_ad.clipsToBounds = true
        
        btn_rewarded_interstitial_ad.backgroundColor = .white
        btn_rewarded_interstitial_ad.layer.cornerRadius = 10
        btn_rewarded_interstitial_ad.layer.borderWidth = 1
        btn_rewarded_interstitial_ad.layer.borderColor = UIColor(hex: "#aaaaaa")?.cgColor
        btn_rewarded_interstitial_ad.clipsToBounds = true
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func setListener() {
        btn_rewarded_ad.setOnClickListener {
            self.onRewardedAd()
            self.dismiss()
        }
        btn_rewarded_interstitial_ad.setOnClickListener {
            self.onRewardedInterstitialAd()
            self.dismiss()
        }
    }
    
}
