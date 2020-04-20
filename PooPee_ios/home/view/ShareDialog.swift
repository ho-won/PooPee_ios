//
//  CommentReportDialog.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/11/06.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import MessageUI
import KakaoLink
import KakaoMessageTemplate

class ShareDialog: BaseDialog, MFMessageComposeViewControllerDelegate {
    static let ACTION_NAVI = "ACTION_NAVI"
    static let ACTION_SHARE = "ACTION_SHARE"
    
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var btn_close: UIButton!
    
    @IBOutlet var layout_01: UIView!
    @IBOutlet var iv_01: UIImageView!
    @IBOutlet var tv_01: UILabel!
    
    @IBOutlet var layout_02: UIView!
    @IBOutlet var iv_02: UIImageView!
    @IBOutlet var tv_02: UILabel!
    
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
            tv_title.text = "home_text_16".localized
            tv_01.text = "home_text_18".localized
            tv_02.text = "home_text_19".localized
            iv_01.image = UIImage(named: "ic_tmap")
            iv_02.image = UIImage(named: "ic_kakaonavi")
        } else if (mAction == ShareDialog.ACTION_SHARE) {
            tv_title.text = "home_text_17".localized
            tv_01.text = "home_text_20".localized
            tv_02.text = "home_text_21".localized
            iv_01.image = UIImage(named: "ic_kakaotalk")
            iv_02.image = UIImage(named: "ic_sms")
        }
        
        mAddressText = ""
        if (mToilet.address_new.count > 0) {
            mAddressText = mToilet.address_new
        } else if (mToilet.address_old.count > 0) {
            mAddressText = mToilet.address_old
        }
    }
    
    func setListener() {
        layout_01.setOnClickListener {
            if (self.mAction == ShareDialog.ACTION_NAVI) {
                UIApplication.shared.open(URL(string: "https://apis.openapi.sk.com/tmap/app/routes?appKey=\(NetDefine.TMAP_API_KEY)&name=\(self.mAddressText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&lon=\(self.mToilet.longitude)&lat=\(self.mToilet.latitude)")!, options: [:], completionHandler: nil)
            } else if (self.mAction == ShareDialog.ACTION_SHARE) {
                let template = KMTLocationTemplate { (templateBuilder) in
                    templateBuilder.address = self.mAddressText
                    templateBuilder.addressTitle = self.mToilet.name
                    templateBuilder.buttonTitle = "home_text_15".localized
                    
                    templateBuilder.content = KMTContentObject { (contentBuilder) in
                        contentBuilder.title = "home_text_14".localized + self.mAddressText
                        contentBuilder.imageHeight = 0
                        contentBuilder.imageURL = URL.init(string: "http://poopee.ho1.co.kr/image/banner.png")!
                        contentBuilder.link = KMTLinkObject { (linkBuilder) in }
                    }
                }
                
                KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warningMsg, argumentMsg) in }, failure: { (error) in })
            }
            self.dismiss()
        }
        layout_02.setOnClickListener {
            if (self.mAction == ShareDialog.ACTION_NAVI) {
                let destination = KNVLocation(name: self.mAddressText, x: NSNumber(value: self.mToilet.longitude), y: NSNumber(value: self.mToilet.latitude))
                let options = KNVOptions()
                options.routeInfo = true
                options.coordType = .WGS84
                let params = KNVParams(destination: destination, options: options)
                KNVNaviLauncher.shared().navigate(with: params) { (error) in
                    
                }
            } else if (self.mAction == ShareDialog.ACTION_SHARE) {
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate = self
                messageController.body = "home_text_14".localized + self.mAddressText
                ObserverManager.root.present(messageController, animated: true, completion: nil)
            }
            self.dismiss()
        }
        btn_close.setOnClickListener {
            self.dismiss()
        }
    }

    func setAction(_ action: String) {
        mAction = action
    }
    
    func setToilet(_ toilet: Toilet) {
        mToilet = toilet
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
