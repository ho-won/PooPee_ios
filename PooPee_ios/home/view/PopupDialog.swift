//
//  PopupDialog.swift
//  PooPee_ios
//
//  Created by ho1 on 08/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Kingfisher

class PopupDialog: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    @IBOutlet var iv_popup: UIImageView!
    @IBOutlet var iv_popup_height: NSLayoutConstraint!
    
    @IBOutlet var layout_btn: UIView!
    @IBOutlet var btn_show: UIButton!
    @IBOutlet var btn_close: UIButton!
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("PopupDialog", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        layout_btn.cornerRadius(corner: [.bottomLeft, .bottomRight], radius: 2)
        
        btn_show.setTitle("dialog_no_show".localized, for: .normal)
        btn_close.setTitle("close".localized, for: .normal)
        
        _init()
        setListener()
    }
    
    func _init() {
        var imageName = SharedManager.instance.getNoticeImage()
        if (Locale.current.languageCode != "ko") {
            let array = imageName.split(separator: ".")
            imageName = array[0] + "_en." + array[1]
        }
        iv_popup.kf.setImage(with: URL(string: NetDefine.BASE_APP + imageName)) { result in
            switch result {
            case .success(let value):
                self.iv_popup_height.constant = value.image.size.height / (value.image.size.width / self.iv_popup.frame.width)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        btn_show.setOnClickListener {
            SharedManager.instance.setNoticeImage(value: "")
            SharedManager.instance.setNoticeDate(value: StrManager.getCurrentDate())
            self.dismiss()
        }
        btn_close.setOnClickListener {
            self.dismiss()
        }
    }
    
}
