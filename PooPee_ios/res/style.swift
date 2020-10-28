//
//  style.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 8..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit

/*
 * 툴바뷰(primary)
 */
class toolbar: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.backgroundColor = colors.primary
    }
}

/*
 * 툴바뷰 title(primary) 
 */
class toolbar_tv_title: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.textColor = colors.toolbar_title
        self.font = UIFont.boldSystemFont(ofSize: 19)
    }
}

class main_line: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.backgroundColor = colors.main_line
    }
}

/*
 * 뷰(바텀라인)
 * 공통
 */
class view_bottom_line: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.addBorders(edges: [.bottom], color: colors.main_line, inset: 0, thickness: dimen.main_line_height)
    }
}

class bg_my_position: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 18
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        self.backgroundColor = colors.primary
    }
}

class bg_search_layout: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.backgroundColor = colors.main_content_background
    }
}

class bg_search_edt: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor(hex: "#F9F9F9")!
    }
}

class bg_login: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 24
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.backgroundColor = colors.main_content_background
        self.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        setEnabled(enable: false)
    }
    
    func setEnabled(enable: Bool) {
        self.isEnabled = enable
        if (enable) {
            self.setTitleColor(colors.primary, for: .normal)
        } else {
            self.setTitleColor(UIColor(hex: "#85b3ff"), for: .normal)
        }
    }
}

class cb_up_down: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_tap_up")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_tap_down")!, for: UIControl.State.normal)
        }
    }
}

class cb_up_down_notice: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_tap_seleted")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_tap_down")!, for: UIControl.State.normal)
        }
    }
}

class cb_option_01: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_public_pressed")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_public_normal")!, for: UIControl.State.normal)
        }
    }
}

class cb_option_02: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_man_pressed")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_man_normal")!, for: UIControl.State.normal)
        }
    }
}

class cb_option_03: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_woman_pressed")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_woman_normal")!, for: UIControl.State.normal)
        }
    }
}

class cb_option_04: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_disorder_pressed")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_disorder_normal")!, for: UIControl.State.normal)
        }
    }
}

class cb_option_05: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_mchild_pressed")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_mchild_normal")!, for: UIControl.State.normal)
        }
    }
}

class cb_option_06: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_wchild_pressed")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_wchild_normal")!, for: UIControl.State.normal)
        }
    }
}

class btn_like: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_good_pressed")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_good_normal")!, for: UIControl.State.normal)
        }
    }
}

class dash: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.addDashedBorder(lineWidth: 1, color: colors.main_line)
    }
}

class bg_layout_like: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(hex: "#d3d6db")!.cgColor
        self.layer.cornerRadius = 16
    }
}

class btn_comment_send: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setEnabled(false)
    }
    func setEnabled(_ enable: Bool) {
        self.isSelected = enable
        if (self.isSelected) {
            self.setImage(UIImage(named: "btn_send_pressed")!, for: UIControl.State.normal)
            self.isUserInteractionEnabled = true
        } else {
            self.setImage(UIImage(named: "btn_send_normal")!, for: UIControl.State.normal)
            self.isUserInteractionEnabled = false
        }
    }
}

class edt_commnet: UITextView, UITextViewDelegate {
    var placeholderLabel : UILabel!
    var onTextChanged: (()->())!
    var maxLength: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        _init()
    }
    
    func _init() {
        self.textColor = colors.text_main
        self.font = UIFont.systemFont(ofSize: 16)
//        self.textContainerInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        self.delegate = self
    }
    
    func setHint(hint: String) {
        if (placeholderLabel == nil) {
            placeholderLabel = UILabel()
            placeholderLabel.font = UIFont.systemFont(ofSize: (self.font?.pointSize)!)
            placeholderLabel.sizeToFit()
            placeholderLabel.textColor = colors.main_hint
            placeholderLabel.isHidden = !self.text.isEmpty
            self.addSubview(placeholderLabel)
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                self.placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                self.placeholderLabel.heightAnchor.constraint(equalToConstant: 32)
            ])
        }
        placeholderLabel.text = hint
    }
    
    func setMaxLength(_ length: Int) {
        maxLength = length
    }
    
    func refreshPlaceholder() {
        if (placeholderLabel != nil) {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
    
    override var text: String! {
        didSet {
            if (placeholderLabel != nil) {
                placeholderLabel.isHidden = !self.text.isEmpty
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (placeholderLabel != nil) {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
        if (onTextChanged != nil) {
            onTextChanged()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if (maxLength > 0) {
            return updatedText.count <= maxLength
        } else {
            return true
        }
    }
    
    func addTextChangedListener(_ onTextChanged: @escaping ()->()) {
        self.onTextChanged = onTextChanged
    }
    
}

class base_edt: MyTextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 9
        self.backgroundColor = UIColor(hex: "#F9F9F9")!
        self.textColor = UIColor(hex: "#292d34")
        self.font = UIFont.systemFont(ofSize: 15)
        self.tintColor = colors.primary
        self.paddingTop = 12
        self.paddingBottom = 12
        self.paddingLeft = 12
        self.paddingRight = 12
    }
}

class bg_base_edt: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 9
        self.backgroundColor = UIColor(hex: "#F9F9F9")!
    }
}

class switch_push: UISwitch {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.onTintColor = colors.primary
        self.tintColor = UIColor(hex: "#EDECEF")
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = UIColor(hex: "#EDECEF")
        self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.thumbTintColor = UIColor(hex: "#FFFFFF")
    }
    
    
    /**
     * android setOnCheckedChangedListener 같은용도
     */
    var onChanged: (()->())!
    func setOnCheckedChangedListener(_ onChanged: @escaping ()->()) {
        self.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
        self.onChanged = onChanged
    }
    
    @objc func switchStateDidChange(_ sender:UISwitch!) {
        onChanged()
        if (self.isOn) {
            self.thumbTintColor = UIColor(hex: "#FFFFFF")
        } else {
            self.thumbTintColor = UIColor(hex: "#FFFFFF")
        }
    }
}

class cb_gender_man: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.backgroundColor = .white
            self.setTitleColor(colors.primary, for: .normal)
        } else {
            self.backgroundColor = UIColor(hex: "#F9F9F9")
            self.setTitleColor(UIColor(hex: "#d0d2d5"), for: .normal)
        }
        self.setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        self.cornerRadius(corner: [.topLeft, .bottomLeft], radius: 9)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 9, height: 9))
        if (self.isSelected) {
            colors.primary.setStroke()
        } else {
            UIColor(hex: "#F9F9F9")!.setStroke()
        }
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        
        let cgContext: CGContext = UIGraphicsGetCurrentContext()!
        cgContext.saveGState()
        cgContext.addPath(bezierPath.cgPath)
        cgContext.closePath()
        cgContext.restoreGState()
        self.setNeedsDisplay()
    }
}

class cb_gender_woman: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.backgroundColor = .white
            self.setTitleColor(colors.primary, for: .normal)
        } else {
            self.backgroundColor = UIColor(hex: "#F9F9F9")
            self.setTitleColor(UIColor(hex: "#d0d2d5"), for: .normal)
        }
        self.setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        self.cornerRadius(corner: [.topRight, .bottomRight], radius: 9)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height), byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 9, height: 9))
        if (self.isSelected) {
            colors.primary.setStroke()
        } else {
            UIColor(hex: "#F9F9F9")!.setStroke()
        }
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        
        let cgContext: CGContext = UIGraphicsGetCurrentContext()!
        cgContext.saveGState()
        cgContext.addPath(bezierPath.cgPath)
        cgContext.closePath()
        cgContext.restoreGState()
        self.setNeedsDisplay()
    }
}

class tv_overlap: MyLabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.paddingLeft = 12
        self.paddingRight = 12
        self.font = UIFont.systemFont(ofSize: 13)
        setEnabled(false)
    }
    func setEnabled(_ enabled: Bool) {
        self.isEnabled = enabled
        self.isUserInteractionEnabled = enabled
        if (self.isEnabled) {
            self.textColor = colors.primary
        } else {
            self.textColor = UIColor(hex: "#d0d2d5")
        }
    }
}

class cb_terms: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_checkbox_pressed")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_checkbox_normal")!, for: UIControl.State.normal)
        }
    }
}

class bg_sms: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 18
        self.backgroundColor = UIColor(hex: "#ff536a")!
    }
}

class btn_navi: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.backgroundColor = UIColor(hex: "#FFFFFF")!
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = UIColor(hex: "#f2f6ff")!

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = UIColor(hex: "#FFFFFF")!

    }
    override func draw(_ rect: CGRect) {
        self.cornerRadius(corner: [.topLeft, .bottomLeft], radius: 18)
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 18, height: 18))
        
        let cgContext: CGContext = UIGraphicsGetCurrentContext()!
        cgContext.saveGState()
        cgContext.addPath(bezierPath.cgPath)
        cgContext.closePath()
        cgContext.restoreGState()
        self.setNeedsDisplay()
    }
}

class btn_share: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.backgroundColor = UIColor(hex: "#FFFFFF")!
        self.layoutIfNeeded()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = UIColor(hex: "#f2f6ff")!

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = UIColor(hex: "#FFFFFF")!

    }
    override func draw(_ rect: CGRect) {
        self.cornerRadius(corner: [.topRight, .bottomRight], radius: 18)
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height), byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 18, height: 18))
        
        let cgContext: CGContext = UIGraphicsGetCurrentContext()!
        cgContext.saveGState()
        cgContext.addPath(bezierPath.cgPath)
        cgContext.closePath()
        cgContext.restoreGState()
        self.setNeedsDisplay()
    }
}

class cb_toilet_gubun_public: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_public_p")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_public_n")!, for: UIControl.State.normal)
        }
    }
}

class cb_toilet_gubun_man: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_man_p")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_man_n")!, for: UIControl.State.normal)
        }
    }
}

class cb_toilet_gubun_woman: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        setSelected(selected: false)
    }
    func setSelected(selected: Bool) {
        self.isSelected = selected
        if (self.isSelected) {
            self.setImage(UIImage(named: "ic_woman_p")!, for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "ic_woman_n")!, for: UIControl.State.normal)
        }
    }
}

