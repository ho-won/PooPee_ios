//
//  CommentReportDialog.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/11/06.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit

class ShareDialog: BaseDialog {
    static let ACTION_NAVI = "ACTION_NAVI"
    static let ACTION_SHARE = "ACTION_SHARE"
    
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    var mAction: String = ACTION_NAVI
    var mToilet: Toilet = Toilet()
    var mAddressText: String = ""
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("ShareDialog", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        if (mAction == ShareDialog.ACTION_NAVI) {
            
        } else if (mAction == ShareDialog.ACTION_NAVI) {
            
        }
        
        mAddressText = ""
        if (mToilet.address_new.count > 0) {
            mAddressText = mToilet.address_new
        } else if (mToilet.address_old.count > 0) {
            mAddressText = mToilet.address_old
        }
    }
    
    func setListener() {
        //        layout_sms.setOnClickListener {
        //            var addressText = ""
        //            if (self.mToilet.address_new.count > 0) {
        //                addressText = self.mToilet.address_new
        //            } else {
        //                addressText = self.mToilet.address_old
        //            }
        //            let messageController = MFMessageComposeViewController()
        //            messageController.messageComposeDelegate = self
        //            messageController.body = "home_text_14".localized + addressText
        //            ObserverManager.root.present(messageController, animated: true, completion: nil)
        //        }
        //        btn_tmap.setOnClickListener {
        //            UIApplication.shared.open(URL(string: "https://apis.openapi.sk.com/tmap/app/routes?appKey=\(NetDefine.TMAP_API_KEY)&name=\(self.mAddressText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&lon=\(self.mToilet.longitude)&lat=\(self.mToilet.latitude)")!, options: [:], completionHandler: nil)
        //        }
        //        btn_kakaonavi.setOnClickListener {
        //            let destination = KNVLocation(name: self.mAddressText, x: NSNumber(value: self.mToilet.longitude), y: NSNumber(value: self.mToilet.latitude))
        //            let options = KNVOptions()
        //            options.routeInfo = true
        //            options.coordType = .WGS84
        //            let params = KNVParams(destination: destination, options: options)
        //            KNVNaviLauncher.shared().navigate(with: params) { (error) in
        //
        //            }
        //        }
    }

    func setAction(_ action: String) {
        mAction = action
    }
    
    func setToilet(_ toilet: Toilet) {
        mToilet = toilet
    }
    
}
