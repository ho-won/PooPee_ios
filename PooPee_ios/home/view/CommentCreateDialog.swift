//
//  CommentCreateDialog.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/11/06.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit

class CommentCreateDialog: BaseDialog {
    let edt_comment_min_height: CGFloat = 33
    let edt_comment_max_height: CGFloat = 80
    
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    @IBOutlet var edt_comment: edt_commnet!
    @IBOutlet var edt_comment_height: NSLayoutConstraint!
    @IBOutlet var btn_comment_delete: UIButton!
    @IBOutlet var btn_send: btn_comment_send!
    
    var onCommentCreate: (_ it: String)->()
    
    init(onCommentCreate: @escaping (_ it: String)->()){
        self.onCommentCreate = onCommentCreate
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("CommentCreateDialog", owner: self, options: nil)
        addSubview(root_view)
        
        setupViewResizerOnKeyboardShown()
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        edt_comment_height.constant = edt_comment_min_height
        edt_comment.becomeFirstResponder()
        edt_comment.setHint(hint: "home_text_05".localized)
        edt_comment.setMaxLength(1000)
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        edt_comment.addTextChangedListener {
            self.btn_comment_delete.isHidden = self.edt_comment.text.isEmpty
            self.btn_send.setEnabled(!self.edt_comment.text.isEmpty)
            
            let size = self.edt_comment.sizeThatFits(CGSize(width: self.edt_comment.frame.width, height: .infinity))
            
            if (size.height >= self.edt_comment_max_height) {
                self.edt_comment_height.constant = self.edt_comment_max_height
            } else if (size.height <= self.edt_comment_min_height) {
                self.edt_comment_height.constant = self.edt_comment_min_height
            } else {
                self.edt_comment_height.constant = size.height
            }
            
            if (size.height > self.edt_comment_max_height) {
                self.edt_comment.isScrollEnabled = true
            } else {
                self.edt_comment.isScrollEnabled = false
            }
        }
        btn_comment_delete.setOnClickListener {
            self.edt_comment.text = ""
            self.edt_comment_height.constant = self.edt_comment_min_height
            self.btn_comment_delete.isHidden = true
            self.btn_send.setEnabled(false)
        }
        btn_send.setOnClickListener {
            self.onCommentCreate(self.edt_comment.text)
            self.dismiss()
        }
    }
    
}
