//
//  BaseDialog.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 7. 16..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

class BaseDialog: UIView {
    var layout_bg = UIView()
    var dialog_height: NSLayoutConstraint!
    var dialog_height_origin: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        self.addSubview(layout_bg)
        layout_bg.backgroundColor = .black
        layout_bg.alpha = 0.3
        layout_bg.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func layout_bg_tap(recognizer: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func layout_dialog_tap(recognizer: UITapGestureRecognizer) {
        
    }
    
    func show(view: UIView){
        view.addSubview(self)
        self.isHidden = false
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    // on keyboard view resize
    func setupViewResizerOnKeyboardShown(layout_dialog_height: NSLayoutConstraint, layout_dialog_height_origin: CGFloat) {
        dialog_height = layout_dialog_height
        dialog_height_origin = layout_dialog_height_origin
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // on keyboard view resize
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.frame = CGRect(x: self.frame.origin.x,
                                     y: self.frame.origin.y,
                                     width: self.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
            
            let height = window.origin.y + window.height - keyboardSize.height - 20
            if (dialog_height.constant > height) {
                dialog_height.constant = height
            }
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    // on keyboard view resize
    @objc func keyboardWillHideForResizing(notification: Notification) {
        print("keyboardWillHideForResizing")
        if let window = self.window?.frame {
            self.frame = CGRect(x: self.frame.origin.x,
                                     y: self.frame.origin.y,
                                     width: self.frame.width,
                                     height: window.origin.y + window.height)
            dialog_height.constant = dialog_height_origin
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
    
}
