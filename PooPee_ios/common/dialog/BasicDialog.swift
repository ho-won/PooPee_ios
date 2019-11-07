//
//  BasicDialog.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 8..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

class BasicDialog: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_content: UILabel!
    @IBOutlet var btn_left: UIButton!
    @IBOutlet var btn_right: UIButton!
    
    var onLeftButton: ()->()
    var onRightButton: ()->()
    
    init(onLeftButton: @escaping ()->(), onRightButton: @escaping ()->()){
        self.onRightButton = onRightButton
        self.onLeftButton = onLeftButton
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("BasicDialog", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        tv_content.textColor = colors.dialog_text_content
        tv_content.font = UIFont.systemFont(ofSize: 14)
        
        btn_left.setTitleColor(colors.dialog_text_btn_left, for: .normal)
        btn_left.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 16)
        btn_right.setTitleColor(colors.dialog_text_btn_right, for: .normal)
        btn_right.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 16)
        
        btn_left.setVisibility(gone: true, dimen: 0, attribute: .width)
        btn_right.setVisibility(gone: true, dimen: 0, attribute: .width)
        
        setListener()
    }
    
    func setListener() {
        btn_left.setOnClickListener {
            self.onLeftButton()
            self.dismiss()
        }
        btn_right.setOnClickListener {
            self.onRightButton()
            self.dismiss()
        }
    }
    
    func setTextContent(_ text: String) {
        tv_content.text = text
    }
    
    func setBtnLeft(_ text: String) {
        btn_left.setTitle(text, for: .normal)
        btn_left.setVisibility(gone: false, dimen: 0, attribute: .width)
    }
    
    func setBtnRight(_ text: String) {
        btn_right.setTitle(text, for: .normal)
        btn_right.setVisibility(gone: false, dimen: 0, attribute: .width)
    }
    
}
