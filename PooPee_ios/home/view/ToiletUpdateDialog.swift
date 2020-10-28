//
//  ToiletUpdateDialog.swift
//  PooPee_ios
//
//  Created by ho1 on 2020/10/16.
//  Copyright © 2020 ho1. All rights reserved.
//

import UIKit
import Alamofire

class ToiletUpdateDialog: BaseDialog {
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
    
    var onToiletUpdate: (_ it: Toilet)->()
    var mToilet : Toilet
    
    init(_ toilet: Toilet, onToiletUpdate: @escaping (_ it: Toilet)->()){
        self.mToilet = toilet
        self.onToiletUpdate = onToiletUpdate
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("ToiletUpdateDialog", owner: self, options: nil)
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
        btn_send.setTitle("modified".localized, for: .normal)
        
        _init()
        setListener()
    }
    
    func _init() {
        edt_title.text = mToilet.name
        edt_content.text = mToilet.content
        tv_content_cnt.text = "\(mToilet.content.count)/100"
        
        if (Int(mToilet.m_poo)! > 0) {
            cb_man.setSelected(selected: true)
            cb_woman.setSelected(selected: false)
            cb_public.setSelected(selected: false)
        } else if (Int(mToilet.w_poo)! > 0) {
            cb_man.setSelected(selected: false)
            cb_woman.setSelected(selected: true)
            cb_public.setSelected(selected: false)
        } else {
            cb_man.setSelected(selected: false)
            cb_woman.setSelected(selected: false)
            cb_public.setSelected(selected: true)
        }
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
            self.taskUpdateToilet()
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
     * [POST] 화장실추가
     */
    func taskUpdateToilet() {
        mToilet.name = edt_title.text!
        mToilet.content = edt_content.text!
        
        var params: Parameters = Parameters()
        params.put("member_id", SharedManager.instance.getMemberId())
        params.put("toilet_id", mToilet.toilet_id)
        params.put("name", mToilet.name) // 화장실명
        params.put("content", mToilet.content) // 화장실설명
        
        if (cb_man.isSelected) {
            params.put("type", 1) // 0(공용) 1(남자) 2(여자)
            mToilet.m_poo = "1"
            mToilet.w_poo = "0"
            mToilet.unisex = "N"
        } else if (cb_woman.isSelected) {
            params.put("type", 2) // 0(공용) 1(남자) 2(여자)
            mToilet.m_poo = "0"
            mToilet.w_poo = "1"
            mToilet.unisex = "N"
        } else {
            params.put("type", 0) // 0(공용) 1(남자) 2(여자)
            mToilet.m_poo = "0"
            mToilet.w_poo = "0"
            mToilet.unisex = "Y"
        }
        
        BaseTask().request(url: NetDefine.TOILET_UPDATE, method: .put, params: params
            , onSuccess: { response in
                if (response.getInt("rst_code") == 0) {
                    ObserverManager.root.view.makeToast(message: "toast_update_complete".localized)
                    self.onToiletUpdate(self.mToilet)
                    self.dismiss()
                }
        }
            , onFailed: { statusCode in
                
        })
    }
    
}
