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
    
    var onRightButton: ()->()
    var onLeftButton: ()->()
    
    init(onRightButton: @escaping ()->(), onLeftButton: @escaping ()->()){
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
    }
    
    @IBAction func btn_yes_tap(_ sender: Any) {
        onRightButton()
    }
    
    @IBAction func btn_no_tap(_ sender: Any) {
        onLeftButton()
        dismiss()
    }
    
}
