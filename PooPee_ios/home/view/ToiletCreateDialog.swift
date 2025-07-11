//
//  ToiletCreateDialog.swift
//  PooPee_ios
//
//  Created by ho1 on 2020/10/16.
//  Copyright © 2020 ho1. All rights reserved.
//

import UIKit
import Alamofire

class ToiletCreateDialog: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_title: UILabel!
    
    @IBOutlet var tv_title_sub: UILabel!
    @IBOutlet var edt_title: base_edt!
    
    @IBOutlet var tv_content: UILabel!
    @IBOutlet var tv_content_cnt: UILabel!
    @IBOutlet var edt_content: edt_commnet!
    
    @IBOutlet var tv_type: UILabel!
    @IBOutlet var cb_public: cb_toilet_gubun_public!
    @IBOutlet var cb_man: cb_toilet_gubun_man!
    @IBOutlet var cb_woman: cb_toilet_gubun_woman!
    
    @IBOutlet var btn_close: UIButton!
    @IBOutlet var btn_send: UIButton!
    
    var onToiletCreate: ()->()
    
    var mLatitude: Double = 0
    var mLongitude: Double = 0
    
    init(_ latitude: Double, _ longitude: Double, onToiletCreate: @escaping ()->()){
        self.mLatitude = latitude
        self.mLongitude = longitude
        self.onToiletCreate = onToiletCreate
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("ToiletCreateDialog", owner: self, options: nil)
        addSubview(root_view)
        
        setupViewResizerOnKeyboardShown()
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        tv_title.text = "toilet_create_text_06".localized
        
        tv_title_sub.text = "toilet_create_text_07".localized
        edt_title.setHint(hint: "toilet_create_text_08".localized, color: colors.main_hint)
        
        tv_content.text = "toilet_create_text_09".localized
        edt_content.setHint(hint: "toilet_create_text_10".localized)
        
        tv_type.text = "toilet_create_text_11".localized
        
        btn_close.setTitle("cancel".localized, for: .normal)
        btn_send.setTitle("toilet_create_text_12".localized, for: .normal)
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        edt_title.addTextChangedListener {
            if (self.edt_title.text!.count > 0 && self.isGubunChecked()) {
                self.btn_send.setTitleColor(UIColor(hex: "#2470ff"), for: .normal)
                self.btn_send.isUserInteractionEnabled = true
            } else {
                self.btn_send.setTitleColor(UIColor(hex: "#a0a4aa"), for: .normal)
                self.btn_send.isUserInteractionEnabled = false
            }
        }
        edt_content.addTextChangedListener {
            self.tv_content_cnt.text = "\(self.edt_content.text!.count)/100"
        }
        cb_public.setOnClickListener {
            self.setGubunCheck()
            self.cb_public.setSelected(selected: true)
        }
        cb_man.setOnClickListener {
            self.setGubunCheck()
            self.cb_man.setSelected(selected: true)
        }
        cb_woman.setOnClickListener {
            self.setGubunCheck()
            self.cb_woman.setSelected(selected: true)
        }
        btn_send.setOnClickListener {
            self.taskKakaoCoordToAddress()
        }
        btn_close.setOnClickListener {
            self.dismiss()
        }
    }

    func setGubunCheck() {
        cb_public.setSelected(selected: false)
        cb_man.setSelected(selected: false)
        cb_woman.setSelected(selected: false)
        if (edt_title.text!.count > 0) {
            self.btn_send.setTitleColor(UIColor(hex: "#2470ff"), for: .normal)
            self.btn_send.isUserInteractionEnabled = true
        } else {
            self.btn_send.setTitleColor(UIColor(hex: "#a0a4aa"), for: .normal)
            self.btn_send.isUserInteractionEnabled = false
        }
    }

    func isGubunChecked() -> Bool {
        return cb_public.isSelected || cb_man.isSelected || cb_woman.isSelected
    }
    
    /**
     * [GET] 카카오 좌표 -> 주소 변환
     */
    func taskKakaoCoordToAddress() {
        var params: Parameters = Parameters()
        params.put("x", mLongitude) // longitude
        params.put("y", mLatitude) // latitude
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK " + NetDefine.KAKAO_API_KEY,
        ]
        
        BaseTask().request(url: NetDefine.KAKAO_COORD_TO_ADDRESS, method: .get, params: params, headers: headers, fullUrl: true
            , onSuccess: { it in
                let totalCount = it.getJSONObject("meta").getInt("total_count")
                if (totalCount > 0) {
                    let jsonObject = it.getJSONArray("documents").getJSONObject(0)
                    
                    var address_new = ""
                    var address_old = ""
                    if (jsonObject.getJSONObject("road_address").has("address_name")) {
                        address_new = jsonObject.getJSONObject("road_address").getString("address_name")
                    }
                    if (jsonObject.getJSONObject("address").has("address_name")) {
                        address_old = jsonObject.getJSONObject("address").getString("address_name")
                    }
                    self.taskCreateToilet(address_new, address_old)
                }
        }
            , onFailed: { statusCode in
                
        })
    }

    /**
     * [POST] 화장실추가
     */
    func taskCreateToilet(_ address_new: String, _ address_old: String) {
        ObserverManager.root.showLoading()
        var params: Parameters = Parameters()
        params.put("member_id", SharedManager.memberId)
        params.put("name", edt_title.text!) // 화장실명
        params.put("content", edt_content.text!) // 화장실설명
        
        if (cb_man.isSelected) {
            params.put("type", 1) // 0(공용) 1(남자) 2(여자)
        } else if (cb_woman.isSelected) {
            params.put("type", 2) // 0(공용) 1(남자) 2(여자)
        } else {
            params.put("type", 0) // 0(공용) 1(남자) 2(여자)
        }

        params.put("latitude", mLatitude) // 위도
        params.put("longitude", mLongitude) // 경도
        params.put("address_new", address_new) // 도로명주소
        params.put("address_old", address_old) // 지번주소
        
        BaseTask().request(url: NetDefine.TOILET_CREATE, method: .post, params: params
            , onSuccess: { response in
                if (response.getInt("rst_code") == 0) {
                    self.onToiletCreate()
                    self.dismiss()
                }
                ObserverManager.root.hideLoading()
        }
            , onFailed: { statusCode in
                ObserverManager.root.hideLoading()
        })
    }
    
}
