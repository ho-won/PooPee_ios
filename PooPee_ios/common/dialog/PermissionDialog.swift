//
//  PermissionDialog.swift
//  PooPee_ios
//
//  Created by ho1 on 2020/04/29.
//  Copyright © 2020 ho1. All rights reserved.
//

import UIKit

class PermissionDialog: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_title: UILabel!
    
    @IBOutlet var tv_per_01_title: UILabel!
    @IBOutlet var tv_per_01_content: UILabel!
    
    @IBOutlet var tv_per_02_title: UILabel!
    @IBOutlet var tv_per_02_content: UILabel!
    
    @IBOutlet var tv_ex: UILabel!
    
    @IBOutlet var btn_confirm: UIButton!
    
    var onConfirm: ()->()
    
    init(onConfirm: @escaping ()->()){
        self.onConfirm = onConfirm
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("PermissionDialog", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        tv_title.text = "permission_text_01".localized
        tv_per_01_title.text = "permission_text_02".localized
        tv_per_01_content.text = "permission_text_03".localized
        tv_per_02_title.text = "permission_text_04".localized
        tv_per_02_content.text = "permission_text_05".localized
        tv_ex.text = "permission_text_06".localized
        btn_confirm.setTitle("confirm".localized, for: .normal)
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        btn_confirm.setOnClickListener {
            self.dismiss()
        }
    }
    
}
