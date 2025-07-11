//
//  ToiletReportDialog.swift
//  PooPee_ios
//
//  Created by ho1 on 2020/10/28.
//  Copyright © 2020 ho1. All rights reserved.
//

import UIKit
import Alamofire

class ToiletReportDialog: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var edt_content: edt_commnet!
    @IBOutlet var btn_close: UIButton!
    @IBOutlet var btn_report: UIButton!
    
    var mToilet: Toilet = Toilet()
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("ToiletReportDialog", owner: self, options: nil)
        addSubview(root_view)
        
        setupViewResizerOnKeyboardShown()
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        tv_title.text = "home_text_12".localized
        
        edt_content.becomeFirstResponder()
        edt_content.setHint(hint: "home_text_07".localized)
        
        btn_close.setTitle("cancel".localized, for: .normal)
        btn_report.setTitle("report".localized, for: .normal)
        
        btn_report.setTitleColor(UIColor(hex: "#a0a4aa")!, for: .normal)
        btn_report.isEnabled = false
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        edt_content.addTextChangedListener {
            if (self.edt_content.text == "") {
                self.btn_report.setTitleColor(UIColor(hex: "#a0a4aa")!, for: .normal)
                self.btn_report.isEnabled = false
            } else {
                self.btn_report.setTitleColor(UIColor(hex: "#2470ff")!, for: .normal)
                self.btn_report.isEnabled = true
            }
        }
        btn_report.setOnClickListener {
            self.taskToiletReport()
        }
        btn_close.setOnClickListener {
            self.dismiss()
        }
    }

    func setToilet(_ toilet: Toilet) {
        mToilet = toilet
    }

    /**
     * [POST] 댓글신고
     */
    func taskToiletReport() {
        var params: Parameters = Parameters()
        params.put("member_id", SharedManager.memberId)
        params.put("toilet_id", mToilet.toilet_id)
        params.put("content", edt_content.text!)
        
        BaseTask().request(url: NetDefine.TOILET_REPORT, method: .post, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
                    ObserverManager.root.view.makeToast(message: "toast_report_complete".localized)
                    self.dismiss()
                }
        }
            , onFailed: { statusCode in
                
        })
    }
    
}
