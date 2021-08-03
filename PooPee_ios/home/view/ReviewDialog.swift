//
//  ReviewDialog.swift
//  PooPee_ios
//
//  Created by 서호원 on 2021/08/03.
//  Copyright © 2021 ho1. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewDialog: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet var layout_dialog: UIView!
    @IBOutlet var iv_popup: UIImageView!
    @IBOutlet var iv_popup_height: NSLayoutConstraint!
    
    @IBOutlet var layout_btn: UIView!
    @IBOutlet var btn_reivew: UIButton!
    @IBOutlet var btn_close: UIButton!
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("ReviewDialog", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        layout_btn.cornerRadius(corner: [.bottomLeft, .bottomRight], radius: 2)
        
        btn_reivew.setTitle("reivew".localized, for: .normal)
        btn_close.setTitle("close".localized, for: .normal)
        
        _init()
        setListener()
    }
    
    func _init() {
        var review_image = UIImage(named: "img_popup_tt")!
        if (Locale.current.languageCode != "ko") {
            review_image = UIImage(named: "img_popup_tten")!
        }
        iv_popup.image = review_image
        self.iv_popup_height.constant = review_image.size.height / (review_image.size.width / iv_popup.frame.width)
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        btn_reivew.setOnClickListener {
            ObserverManager.reviewInPlayMarket()
            self.dismiss()
        }
        btn_close.setOnClickListener {
            self.dismiss()
        }
    }
    
}
