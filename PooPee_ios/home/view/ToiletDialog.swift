//
//  ToiletDialog.swift
//  PooPee_ios
//
//  Created by ho1 on 08/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class ToiletDialog: BaseDialog, MFMessageComposeViewControllerDelegate {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var tv_address: UILabel!
    @IBOutlet var tv_comment: UILabel!
    @IBOutlet var tv_comment_count: UILabel!
    @IBOutlet var tv_like: UILabel!
    @IBOutlet var tv_like_count: UILabel!
    
    @IBOutlet var btn_close: UIButton!
    @IBOutlet var btn_detail: UIButton!
    
    @IBOutlet var layout_sms: bg_sms!
    @IBOutlet var tv_sms: UILabel!
    
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
        Bundle.main.loadNibNamed("ToiletDialog", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        tv_sms.text = "home_text_13".localized
        tv_comment.text = "home_text_03".localized
        tv_like.text = "home_text_04".localized
        
        btn_detail.setTitle("home_text_02".localized, for: .normal)
        btn_close.setTitle("close".localized, for: .normal)
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        tv_title.text = mToilet.name
        
        mAddressText = ""
        if (mToilet.address_new.count > 0) {
            mAddressText = mToilet.address_new
        } else if (mToilet.address_old.count > 0) {
            mAddressText = mToilet.address_old
        } else {
            taskKakaoCoordToAddress()
        }
        StrManager.setAddressCopySpan(tv_address: tv_address, addressText: mAddressText)
        
        tv_comment_count.text = mToilet.comment_count
        tv_like_count.text = mToilet.like_count
        
        taskToiletCount()
    }
    
    func setListener() {
        layout_sms.setOnClickListener {
            var addressText = ""
            if (self.mToilet.address_new.count > 0) {
                addressText = self.mToilet.address_new
            } else {
                addressText = self.mToilet.address_old
            }
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.body = "home_text_14".localized + addressText
            ObserverManager.root.present(messageController, animated: true, completion: nil)
        }
        tv_title.setOnClickListener {
            let controller = ObserverManager.getController(name: "ToiletController")
            controller.segueData.putExtra(key: ToiletController.TOILET, data: self.mToilet)
            ObserverManager.root.startPresent(controller: controller)
            self.dismiss()
        }
        btn_detail.setOnClickListener {
            let controller = ObserverManager.getController(name: "ToiletController")
            controller.segueData.putExtra(key: ToiletController.TOILET, data: self.mToilet)
            ObserverManager.root.startPresent(controller: controller)
            self.dismiss()
        }
        btn_close.setOnClickListener {
            self.dismiss()
        }
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
    
    func setToilet(toilet: Toilet) {
        mToilet = toilet
    }
    
    func taskToiletCount() {
        var params: Parameters = Parameters()
        params.put("toilet_id", mToilet.toilet_id)
        
        BaseTask().request(url: NetDefine.TOILET_INFO, method: .get, params: params
            , onSuccess: { response in
                if (response.getInt("rst_code") == 0) {
                    self.mToilet.comment_count = response.getString("comment_count")
                    self.mToilet.like_count = response.getString("like_count")
                    
                    self.tv_comment_count.text = self.mToilet.comment_count
                    self.tv_like_count.text = self.mToilet.like_count
                }
        }
            , onFailed: { statusCode in
                
        })
    }
    
    /**
     * [GET] 카카오 좌표 -> 주소 변환
     */
    func taskKakaoCoordToAddress() {
        var params: Parameters = Parameters()
        params.put("x", mToilet.longitude) // longitude
        params.put("y", mToilet.latitude) // latitude
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK " + NetDefine.KAKAO_API_KEY,
        ]
        
        BaseTask().request(url: NetDefine.KAKAO_COORD_TO_ADDRESS, method: .get, params: params, headers: headers, fullUrl: true
            , onSuccess: { it in
                let totalCount = it.getJSONObject("meta").getInt("total_count")
                if (totalCount > 0) {
                    let jsonObject = it.getJSONArray("documents").getJSONObject(0)
                    
                    var addressText = ""
                    if (jsonObject.getJSONObject("road_address").has("address_name")) {
                        addressText = jsonObject.getJSONObject("road_address").getString("address_name")
                    } else if (jsonObject.getJSONObject("address").has("address_name")) {
                        addressText = jsonObject.getJSONObject("address").getString("address_name")
                    }
                    self.mToilet.address_new = addressText
                    StrManager.setAddressCopySpan(tv_address: self.tv_address, addressText: addressText)
                }
        }
            , onFailed: { statusCode in
                
        })
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
