//
//  MyCustomClass.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 7..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

/**
 * Label (padding, hint 적용)
 */
class MyLabel : UILabel {
    private var _textColor: UIColor = .black
    private var _hint: String = ""
    private var _hintColor: UIColor = .lightGray
    private var _paddingLeft = [UILabel: CGFloat]()
    private var _paddingRight = [UILabel: CGFloat]()
    private var _paddingTop = [UILabel: CGFloat]()
    private var _paddingBottom = [UILabel: CGFloat]()
    
    @IBInspectable var paddingLeft: CGFloat {
        get {
            guard let l = _paddingLeft[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingLeft[self] = newValue
        }
    }
    
    @IBInspectable var paddingRight: CGFloat {
        get {
            guard let l = _paddingRight[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingRight[self] = newValue
        }
    }
    
    @IBInspectable var paddingTop: CGFloat {
        get {
            guard let l = _paddingTop[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingTop[self] = newValue
        }
    }
    
    @IBInspectable var paddingBottom: CGFloat {
        get {
            guard let l = _paddingBottom[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingBottom[self] = newValue
        }
    }
    
    func setHint(hint: String) {
        _hint = hint
        if (self.text != nil && self.text!.count == 0) {
            self.text = _hint
            self.textColor = _hintColor
        }
    }
    
    func setHintColor(hintColor: UIColor) {
        _hintColor = hintColor
        if (_hint == self.text) {
            self.textColor = _hintColor
        }
    }
    
    func setText(text: String) {
        if (text.count > 0) {
            self.text = text
            self.textColor = _textColor
        } else {
            self.text = _hint
            self.textColor = _hintColor
        }
    }
    
    func setTextColor(color: UIColor) {
        _textColor = color
        self.textColor = color
    }
    
    func getText() -> String {
        if (self.text == _hint) {
            return ""
        } else {
            return self.text!
        }
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + paddingLeft + paddingRight,
                      height: size.height + paddingTop + paddingBottom)
    }
    
}

/**
 * TextField (padding 적용)
 */
class MyTextField: UITextField, UITextFieldDelegate {
    
    enum PATTERN {
        case alphanumeric, alphanumeric_hangul
    }
    
    private let PATTERN_ALPHANUMERIC = "^[a-zA-Z0-9]$"
    private let PATTERN_ALPHANUMERIC_HANGUL = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]$"
    private var pattern: String! = nil
    
    private var _paddingLeft = [UITextField: CGFloat]()
    private var _paddingRight = [UITextField: CGFloat]()
    private var _paddingTop = [UITextField: CGFloat]()
    private var _paddingBottom = [UITextField: CGFloat]()
    private var onTextChanged: (()->())!
    
    func setPattern(pattern: PATTERN) {
        self.delegate = self
        if (pattern == .alphanumeric) {
            self.pattern = PATTERN_ALPHANUMERIC
        } else if (pattern == .alphanumeric_hangul) {
            self.pattern = PATTERN_ALPHANUMERIC_HANGUL
        } else {
            self.pattern = nil
        }
    }
    
    func isPatternCheck(string: String) -> Bool {
        if (pattern == nil) {
            return true
        }
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            if let _ = regex.firstMatch(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, string.count)) {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    @IBInspectable var paddingLeft: CGFloat {
        get {
            guard let l = _paddingLeft[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingLeft[self] = newValue
        }
    }
    
    @IBInspectable var paddingRight: CGFloat {
        get {
            guard let l = _paddingRight[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingRight[self] = newValue
        }
    }
    
    @IBInspectable var paddingTop: CGFloat {
        get {
            guard let l = _paddingTop[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingTop[self] = newValue
        }
    }
    
    @IBInspectable var paddingBottom: CGFloat {
        get {
            guard let l = _paddingBottom[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingBottom[self] = newValue
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
    }
    
    func setHint(hint: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: hint, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func addTextChangedListener(_ onTextChanged: @escaping ()->()) {
        self.onTextChanged = onTextChanged
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textfield: UITextField) {
        onTextChanged()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        if (isPatternCheck(string: string) || isBackSpace == -92) {
            return true
        } else {
            return false
        }
    }
    
}

/*
 * TextField (padding, hint 적용)
 */
class MyTextView: UITextView, UITextViewDelegate {
    private var _hintLabel: UILabel = UILabel()
    private var _hint: String = ""
    private var _hintColor: UIColor = .lightGray
    private var _paddingLeft = [UITextView: CGFloat]()
    private var _paddingRight = [UITextView: CGFloat]()
    private var _paddingTop = [UITextView: CGFloat]()
    private var _paddingBottom = [UITextView: CGFloat]()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        DispatchQueue.main.async {
            self.textContainer.lineFragmentPadding = 0
            self.textContainerInset = UIEdgeInsets.init(top: self.paddingTop, left: self.paddingLeft, bottom: self.paddingBottom, right: self.paddingRight)
        }
    }
    
    @IBInspectable var paddingLeft: CGFloat {
        get {
            guard let l = _paddingLeft[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingLeft[self] = newValue
        }
    }
    
    @IBInspectable var paddingRight: CGFloat {
        get {
            guard let l = _paddingRight[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingRight[self] = newValue
        }
    }
    
    @IBInspectable var paddingTop: CGFloat {
        get {
            guard let l = _paddingTop[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingTop[self] = newValue
        }
    }
    
    @IBInspectable var paddingBottom: CGFloat {
        get {
            guard let l = _paddingBottom[self] else {
                return 0
            }
            return l
        }
        set {
            _paddingBottom[self] = newValue
        }
    }
    
    func setHint(hint: String) {
        self.addSubview(_hintLabel)
        
        _hintLabel.text = hint
        _hintLabel.font = UIFont.systemFont(ofSize: (self.font?.pointSize)!)
        _hintLabel.sizeToFit()
        _hintLabel.frame.origin = CGPoint(x: paddingLeft, y: paddingTop)
        _hintLabel.textColor = _hintColor
        
        if (self.text!.count > 0) {
            _hintLabel.isHidden = true
        } else {
            _hintLabel.isHidden = false
        }
        
        self.delegate = self
    }
    
    func setHintColor(hintColor: UIColor) {
        _hintColor = hintColor
        _hintLabel.textColor = _hintColor
    }
    
    override var text: String! {
        didSet {
            if (self.text!.count > 0) {
                _hintLabel.isHidden = true
            } else {
                _hintLabel.isHidden = false
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (self.text!.count > 0) {
            _hintLabel.isHidden = true
        } else {
            _hintLabel.isHidden = false
        }
    }
    
}

/**
 * Segue animation (left to right)
 */
class SegueFromLeft: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        dst.modalPresentationStyle = .fullScreen
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

/**
 * Segue animation (right to left)
 */
class SegueFromRight: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        dst.modalPresentationStyle = .fullScreen
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

/**
 * UITapGestureRecognizer (tableView에서 listener연결시 cell의 값 전달용)
 */
class CellRecongnizer: UITapGestureRecognizer {
    var cell: UITableViewCell!
    var position: Int!
    var indexPath: IndexPath!
}

/**
 * UITapGestureRecognizer (tab item)
 */
class TabRecongnizer: UITapGestureRecognizer {
    var position: Int!
    var onClick: (()->())!
}
