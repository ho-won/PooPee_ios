//
//  CommentReportDialog.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/11/06.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import MapKit
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
    @IBOutlet var layout_01_width: NSLayoutConstraint!
    @IBOutlet var iv_01: UIImageView!
    @IBOutlet var tv_01: UILabel!
    
    @IBOutlet var layout_02: UIView!
    @IBOutlet var layout_02_width: NSLayoutConstraint!
    @IBOutlet var iv_02: UIImageView!
    @IBOutlet var tv_02: UILabel!
    
    @IBOutlet var layout_03: UIView!
    @IBOutlet var layout_03_width: NSLayoutConstraint!
    @IBOutlet var iv_03: UIImageView!
    @IBOutlet var tv_03: UILabel!
    
    @IBOutlet var layout_04: UIView!
    @IBOutlet var iv_04: UIImageView!
    @IBOutlet var tv_04: UILabel!
    
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
            layout_01_width.setMultiplier(multiplier: 0.25)
            layout_02_width.setMultiplier(multiplier: 0.25)
            layout_03_width.setMultiplier(multiplier: 0.25)
            layout_03.isHidden = false
            layout_04.isHidden = false
            
            tv_title.text = "home_text_16".localized
            tv_content.text = "home_text_22".localized
            tv_01.text = "home_text_19".localized
            tv_02.text = "home_text_18".localized
            tv_03.text = "home_text_26".localized
            tv_04.text = "home_text_28".localized
            iv_01.image = UIImage(named: "ic_kakaonavi")
            iv_02.image = UIImage(named: "ic_tmap")
            iv_03.image = UIImage(named: "ic_navermap")
            iv_04.image = UIImage(named: "ic_apple_map")
        } else if (mAction == ShareDialog.ACTION_SHARE) {
            layout_01_width.setMultiplier(multiplier: 0.5)
            layout_02_width.setMultiplier(multiplier: 0.5)
            layout_03_width.setMultiplier(multiplier: 0.0)
            layout_03.isHidden = true
            layout_04.isHidden = true
            
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
                let destination = NaviLocation(name: self.mAddressText, x:  "\(self.mToilet.longitude)", y: "\(self.mToilet.latitude)")
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
            } else if (self.mAction == ShareDialog.ACTION_SHARE) {
                let locationTemplateJsonStringData =
                    """
                    {
                        "object_type": "location",
                        "address_title": "\(self.mToilet.name)",
                        "address": "\(self.mAddressText)",
                        "content": {
                            "image_url": "http://poopee.ho1.co.kr/image/banner.png",
                            "image_width": 1024,
                            "image_height": 500,
                            "link": {
                                "mobile_web_url": "http://poopee.ho1.co.kr/etcs/app_install",
                                "web_url": "http://poopee.ho1.co.kr/etcs/app_install"
                            },
                            "title": "[PooPee]\\n내 현재 위치 입니다!\\n\(self.mAddressText)"
                        },
                    }
                    """.data(using: .utf8)!
                
                var safariViewController : SFSafariViewController? // to keep instance
                guard let templatable = try? SdkJSONDecoder.custom.decode(LocationTemplate.self, from: locationTemplateJsonStringData) else {
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
            }
        }
        layout_02.setOnClickListener {
            if (self.mAction == ShareDialog.ACTION_NAVI) {
                UIApplication.shared.open(URL(string: "https://apis.openapi.sk.com/tmap/app/routes?appKey=\(NetDefine.TMAP_API_KEY)&name=\(self.mAddressText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&lon=\(self.mToilet.longitude)&lat=\(self.mToilet.latitude)")!, options: [:], completionHandler: nil)
            } else if (self.mAction == ShareDialog.ACTION_SHARE) {
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate = self
                messageController.body = "home_text_14".localized + self.mAddressText
                ObserverManager.root.present(messageController, animated: true, completion: nil)
            }
        }
        layout_03.setOnClickListener {
            if (self.mAction == ShareDialog.ACTION_NAVI) {
                let url = URL(string: "nmap://navigation?dlat=\(self.mToilet.latitude)&dlng=\(self.mToilet.longitude)&dname=\(self.mAddressText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&appname=kr.co.ho1.poopee")!
                let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!

                if UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.open(url)
                } else {
                  UIApplication.shared.open(appStoreURL)
                }
            } else if (self.mAction == ShareDialog.ACTION_SHARE) {
                
            }
        }
        layout_04.setOnClickListener {
            if (self.mAction == ShareDialog.ACTION_NAVI) {
                let destinationCoordinate = CLLocationCoordinate2D(latitude: self.mToilet.latitude, longitude: self.mToilet.longitude)
                let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                destinationMapItem.name = self.mAddressText
                destinationMapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            } else if (self.mAction == ShareDialog.ACTION_SHARE) {
                
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
    
    func onAppleMap() {
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
