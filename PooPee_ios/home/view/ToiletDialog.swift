//
//  ToiletDialog.swift
//  PooPee_ios
//
//  Created by ho1 on 08/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire

class ToiletDialog: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var tv_address: UILabel!
    @IBOutlet var layout_copy: UIView!
    @IBOutlet var tv_copy: UILabel!
    @IBOutlet var tv_comment: UILabel!
    @IBOutlet var tv_comment_count: UILabel!
    @IBOutlet var tv_like: UILabel!
    @IBOutlet var tv_like_count: UILabel!
    
    @IBOutlet var btn_close: UIButton!
    @IBOutlet var btn_detail: UIButton!
    
    var mToilet: Toilet = Toilet()
    
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
        
        tv_copy.text = "copy".localized
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

        if (mToilet.address_new.count > 0) {
            tv_address.text = mToilet.address_new
        } else {
            tv_address.text = mToilet.address_old
        }

        tv_comment_count.text = mToilet.comment_count
        tv_like_count.text = mToilet.like_count

        taskToiletCount()
    }
    
    func setListener() {
        layout_copy.setOnClickListener {
            UIPasteboard.general.string = self.tv_address.text
            ObserverManager.root.view.makeToast(message: "toast_copy_complete".localized)
        }
        btn_detail.setOnClickListener {
            let controller = ObserverManager.getController(name: "ToiletController")
            controller.segueData.putExtra(key: ToiletController.TOILET, data: self.mToilet)
            ObserverManager.root.startPresent(controller: controller)
        }
        btn_close.setOnClickListener {
            self.dismiss()
        }
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
    
}
