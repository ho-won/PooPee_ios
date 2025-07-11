//
//  CommentUpdateDialog.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/11/06.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire

class CommentUpdateDialog: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var edt_content: edt_commnet!
    @IBOutlet var btn_close: UIButton!
    @IBOutlet var btn_update: UIButton!
    
    var onUpdate: (_ comment: Comment)->()
    
    var mComment: Comment = Comment()
    
    init(onUpdate: @escaping (_ comment: Comment)->()){
        self.onUpdate = onUpdate
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("CommentUpdateDialog", owner: self, options: nil)
        addSubview(root_view)
        
        setupViewResizerOnKeyboardShown()
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        tv_title.text = "home_text_11".localized
        
        edt_content.becomeFirstResponder()
        edt_content.setHint(hint: "home_text_05".localized)
        
        btn_close.setTitle("cancel".localized, for: .normal)
        btn_update.setTitle("modified".localized, for: .normal)
        
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
                self.btn_update.setTitleColor(UIColor(hex: "#a0a4aa")!, for: .normal)
                self.btn_update.isEnabled = false
            } else {
                self.btn_update.setTitleColor(UIColor(hex: "#2470ff")!, for: .normal)
                self.btn_update.isEnabled = true
            }
        }
        btn_update.setOnClickListener {
            self.mComment.content = self.edt_content.text
            self.taskCommentUpdate()
        }
        btn_close.setOnClickListener {
            self.dismiss()
        }
    }

    func setComment(_ comment: Comment) {
        mComment = comment
        edt_content.text = mComment.content
    }

    /**
     * [PUT] 댓글수정
     */
    func taskCommentUpdate() {
        var params: Parameters = Parameters()
        params.put("member_id", SharedManager.memberId)
        params.put("comment_id", mComment.comment_id)
        params.put("content", mComment.content)
        
        BaseTask().request(url: NetDefine.COMMENT_UPDATE, method: .put, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
                    self.onUpdate(self.mComment)
                    self.dismiss()
                }
        }
            , onFailed: { statusCode in
                
        })
    }
    
}
