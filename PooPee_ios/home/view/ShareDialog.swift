//
//  CommentReportDialog.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/11/06.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import MessageUI
import KakaoSDKNavi
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate
import SafariServices

class ShareDialog: BaseDialog, MFMessageComposeViewControllerDelegate {
    static let ACTION_NAVI = "ACTION_NAVI"
    static let ACTION_SHARE = "ACTION_SHARE"
    
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var btn_close: UIButton!
    @IBOutlet var tv_content: UILabel!
    
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
        
        layout_dialog.layer.cornerRadius = 20
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        if (mAction == ShareDialog.ACTION_NAVI) {
            tv_title.text = "home_text_16".localized
            tv_content.text = "home_text_22".localized
            tv_01.text = "home_text_18".localized
            tv_02.text = "home_text_19".localized
            iv_01.image = UIImage(named: "ic_tmap")
            iv_02.image = UIImage(named: "ic_kakaonavi")
        } else if (mAction == ShareDialog.ACTION_SHARE) {
            tv_title.text = "home_text_17".localized
            tv_content.text = "home_text_23".localized
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
                let locationTemplateJsonStringData =
                    """
                    {
                        "object_type": "location",
                        "address_title": "카카오 판교오피스 카페톡",
                        "address": "경기 성남시 분당구 판교역로 235 에이치스퀘어 N동 8층",
                        "content": {
                            "description": "이번 주는 체리블라썸라떼 1+1",
                            "image_url": "https://mud-kage.kakao.com/dn/bSbH9w/btqgegaEDfW/vD9KKV0hEintg6bZT4v4WK/kakaolink40_original.png",
                            "link": {
                                "mobile_web_url": "https://developers.kakao.com",
                                "web_url": "https://developers.com"
                            },
                            "title": "신메뉴 출시❤️ 체리블라썸라떼"
                        },
                        "social": {
                            "comment_count": 45,
                            "like_count": 286,
                            "shared_count": 845
                        }
                    }
                    """.data(using: .utf8)!
                
                var safariViewController : SFSafariViewController? // to keep instance
                guard let templatable = try? SdkJSONDecoder.custom.decode(FeedTemplate.self, from: locationTemplateJsonStringData) else {
                    return
                }
                
                // 카카오톡 설치여부 확인
                if ShareApi.isKakaoTalkSharingAvailable() {
                    // 카카오톡으로 카카오톡 공유 가능
                    // templatable은 메시지 만들기 항목 참고
                    ShareApi.shared.shareDefault(templatable: templatable) {(sharingResult, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("shareDefault() success.")
                            
                            if let sharingResult = sharingResult {
                                UIApplication.shared.open(sharingResult.url,
                                                          options: [:], completionHandler: nil)
                            }
                        }
                    }
                } else {
                    // 카카오톡 미설치: 웹 공유 사용 권장
                    // Custom WebView 또는 디폴트 브라우져 사용 가능
                    // 웹 공유 예시 코드
                    if let url = ShareApi.shared.makeDefaultUrl(templatable: templatable) {
                        safariViewController = SFSafariViewController(url: url)
                        safariViewController?.modalTransitionStyle = .crossDissolve
                        safariViewController?.modalPresentationStyle = .overCurrentContext
                        ObserverManager.root.present(safariViewController!, animated: true) {
                            print("웹 present success")
                        }
                    }
                }
                
                //                let template = KMTLocationTemplate { (templateBuilder) in
                //                    templateBuilder.address = self.mAddressText
                //                    templateBuilder.addressTitle = self.mToilet.name
                //                    templateBuilder.buttonTitle = "home_text_15".localized
                //
                //                    templateBuilder.content = KMTContentObject { (contentBuilder) in
                //                        contentBuilder.title = "home_text_14".localized + self.mAddressText
                //                        contentBuilder.imageWidth = 1024
                //                        contentBuilder.imageHeight = 500
                //                        contentBuilder.imageURL = URL.init(string: "http://poopee.ho1.co.kr/image/banner.png")!
                //                        contentBuilder.link = KMTLinkObject { (linkBuilder) in }
                //                    }
                //                }
                //
                //                KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warningMsg, argumentMsg) in }, failure: { (error) in })
            }
        }
        layout_02.setOnClickListener {
            if (self.mAction == ShareDialog.ACTION_NAVI) {
//                let destination = NaviLocation(name: self.mAddressText, x: String(self.mToilet.longitude), y: String(self.mToilet.latitude))
//                let option = NaviOption(coordType: .WGS84)
//                
//                guard let navigateUrl = NaviApi.shared.shareUrl(destination: destination, option: option) else {
//                    return
//                }
//                
//                if UIApplication.shared.canOpenURL(navigateUrl) {
//                    UIApplication.shared.open(navigateUrl, options: [:], completionHandler: nil)
//                } else {
//                    UIApplication.shared.open(NaviApi.webNaviInstallUrl, options: [:], completionHandler: nil)
//                }
                
                let destination = NaviLocation(name: "카카오판교오피스", x: "127.108640", y: "37.402111")
                let option = NaviOption(coordType: .WGS84)
                guard let shareUrl = NaviApi.shared.shareUrl(destination: destination, option: option) else {
                    return
                }
                if UIApplication.shared.canOpenURL(shareUrl) {
                    UIApplication.shared.open(shareUrl, options: [:], completionHandler: nil)
                }
                else {
                    UIApplication.shared.open(NaviApi.webNaviInstallUrl, options: [:], completionHandler: nil)
                }
                
                //                let destination = KNVLocation(name: self.mAddressText, x: NSNumber(value: self.mToilet.longitude), y: NSNumber(value: self.mToilet.latitude))
                //                let options = KNVOptions()
                //                options.routeInfo = true
                //                options.coordType = .WGS84
                //                let params = KNVParams(destination: destination, options: options)
                //                KNVNaviLauncher.shared().navigate(with: params) { (error) in
                //
                //                }
            } else if (self.mAction == ShareDialog.ACTION_SHARE) {
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate = self
                messageController.body = "home_text_14".localized + self.mAddressText
                ObserverManager.root.present(messageController, animated: true, completion: nil)
            }
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
