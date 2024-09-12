//
//  MyExtension.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 7..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
    
}

extension UIView {
    
    /**
     * border 추가
     */
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            border.tag = 1000
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
    
    func cornerRadius(corner: UIRectCorner, radius: Int) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    /**
     * 마름모형태로 변경
     */
    func addDiamondMask(cornerRadius: CGFloat = 0) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY + cornerRadius))
        path.addLine(to: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY - cornerRadius))
        path.addLine(to: CGPoint(x: bounds.minX + cornerRadius, y: bounds.midY))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = cornerRadius * 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        layer.mask = shapeLayer
    }
    
    /**
     * android setVisibility와 같은용도
     * gone이 false고 dimen 값이 0이면 content size에따라 size 변경
     * gone이 false고 dimen 값이 0이 아니면 content size는 dimen
     */
    func setVisibility(gone: Bool, dimen: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        for constraint in self.constraints {
            if (constraint.firstAttribute == attribute) {
                self.removeConstraint(constraint)
            }
        }
        
        if (gone) {
            self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0))
        } else {
            var relate = NSLayoutConstraint.Relation.greaterThanOrEqual
            if (dimen > 0) {
                relate = NSLayoutConstraint.Relation.equal
            }
            
            self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relate, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: dimen))
        }
        
        self.isHidden = gone
        
//        if (attribute == .width) {
//            DispatchQueue.main.async {
//                self.translatesAutoresizingMaskIntoConstraints = true
//            }
//        }
    }
    
    /**
     * toast
     */
    func makeToast(message: String, duration: TimeInterval = 2) {
        let toast = MyLabel()
        toast.paddingLeft = 15
        toast.paddingRight = 15
        toast.paddingTop = 5
        toast.paddingBottom = 5
        
        toast.alpha = 0
        toast.numberOfLines = 0
        toast.clipsToBounds = true
        toast.backgroundColor = .black
        toast.textColor = .white
        toast.text = message
        
        addSubview(toast)
        
        toast.translatesAutoresizingMaskIntoConstraints = false
        
        toast.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        toast.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 30).isActive = true
        toast.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -30).isActive = true
        toast.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        toast.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        toast.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toast.layoutIfNeeded()
        toast.layer.cornerRadius = 15
        toast.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (self.frame.width - toast.frame.width) / 2).isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
            toast.alpha = 0.8
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                toast.alpha = 0
            }, completion: {_ in
                toast.removeFromSuperview()
            })
        }
    }
    
    func addDashedBorder(lineWidth: CGFloat, lineDashPattern: [NSNumber] = [2, 3], color: UIColor) {
        DispatchQueue.main.async {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineDashPattern = lineDashPattern
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)])
            shapeLayer.path = path
            
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    /**
     * android setOnClickListener 같은용도
     */
    func setOnClickListener(_ onClick: @escaping ()->()) {
        self.isUserInteractionEnabled = true
        let tabRecongnizer = TabRecongnizer(target: self, action: #selector(onClick(recognizer:)))
        tabRecongnizer.onClick = onClick
        tabRecongnizer.cancelsTouchesInView = false
        addGestureRecognizer(tabRecongnizer)
    }
    
    @objc private func onClick(recognizer: TabRecongnizer) {
        recognizer.onClick()
    }
    
}

extension UIViewController {
    
    /**
     * view resize listener 세팅 (Controller)
     */
    @objc func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    /**
     * show keyboard view resize listener (Controller)
     */
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if (UIApplication.shared.applicationState != .active) {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     * hide keyboard view resize listener (Controller)
     */
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if (UIApplication.shared.applicationState != .active || self.view.frame.height == MyUtil.screenHeight) {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     * view click hide keyboard
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /**
     * hide keyboard listener
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension String {
    
    subscript(_ range: NSRange) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let subString = self[start..<end]
        return String(subString)
    }
    
    /**
     * Localizable.strings 에서 해당 String 반환
     */
    var localized: String {
        // %d 숫자 %@ 문자
        // String(format: "test".localized, 0)
        return NSLocalizedString(self, comment: "")
    }
    
    /**
     * 길이제한
     */
    func maxLength(length n: Int) -> String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    /**
     * 대소문자 구분없이 문자열 찾기
     */
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    /**
     * html 적용
     */
    func convertHtml() -> NSAttributedString {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
}

extension UIScrollView {
    
    func scrollToLeft(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let desiredOffset = CGPoint(x: -self.contentInset.left, y: 0)
            self.setContentOffset(desiredOffset, animated: animated)
        }
    }
    
    func scrollToRight(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let desiredOffset = CGPoint(x: self.contentSize.width - self.bounds.size.width, y: 0)
            self.setContentOffset(desiredOffset, animated: animated)
        }
    }
    
    func scrollToTop(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let desiredOffset = CGPoint(x: 0, y: -self.contentInset.top)
            self.setContentOffset(desiredOffset, animated: animated)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let desiredOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
            self.setContentOffset(desiredOffset, animated: animated)
        }
    }
    
}

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = self.textAlignment
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    func setTextResize(per: CGFloat, baseSize: CGFloat, addMaxSize: CGFloat) {
        self.font = self.font.withSize(baseSize + (addMaxSize * per / 100))
    }
    
    func setAlphaResize(per: CGFloat) {
        self.alpha = per / 100
    }
    
    /**
     * html 적용
     */
    func convertHtml(htmlStr: String) {
        let font = self.font
        let textAlignment = self.textAlignment
        do {
            try self.attributedText = NSAttributedString(data: Data(htmlStr.utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            self.textAlignment = textAlignment
            self.font = font
        } catch {
            self.text = htmlStr
        }
    }
    
    func xPositionOfSubstring(substring: String) -> CGFloat? {
        // 전체 텍스트가 있는지 확인
        guard let fullText = self.text else { return nil }

        // 서브스트링의 range 찾기
        guard let range = fullText.range(of: substring) else { return nil }

        // NSRange로 변환
        let nsRange = NSRange(range, in: fullText)

        // UILabel의 attributedText를 기반으로 텍스트 속성 가져오기
        let attributedText = self.attributedText ?? NSAttributedString(string: fullText)
        
        // UILabel의 크기와 속성을 기반으로 boundingRect 계산
        let textStorage = NSTextStorage(attributedString: attributedText)
        let textContainer = NSTextContainer(size: self.bounds.size)
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // 레이아웃 매니저에서 글자의 범위에 대한 사각형을 구함
        var glyphRange = NSRange(location: 0, length: 0)
        layoutManager.characterRange(forGlyphRange: nsRange, actualGlyphRange: &glyphRange)
        
        var textBoundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
        // UILabel의 origin을 기준으로 변환된 x 값을 반환
        textBoundingRect.origin.x += self.frame.origin.x
        
        return textBoundingRect.origin.x
    }
    
    func widthOfSubstring(substring: String) -> CGFloat? {
        // 전체 텍스트가 있는지 확인
        guard let fullText = self.text else { return nil }

        // 서브스트링의 range 찾기
        guard let range = fullText.range(of: substring) else { return nil }

        // NSRange로 변환
        let nsRange = NSRange(range, in: fullText)

        // UILabel의 attributedText를 기반으로 텍스트 속성 가져오기
        let attributedText = self.attributedText ?? NSAttributedString(string: fullText)
        
        // UILabel의 크기와 속성을 기반으로 boundingRect 계산
        let textStorage = NSTextStorage(attributedString: attributedText)
        let textContainer = NSTextContainer(size: self.bounds.size)
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // 레이아웃 매니저에서 글자의 범위에 대한 사각형을 구함
        var glyphRange = NSRange(location: 0, length: 0)
        layoutManager.characterRange(forGlyphRange: nsRange, actualGlyphRange: &glyphRange)
        
        let textBoundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)

        // 특정 단어의 width 반환
        return textBoundingRect.width
    }
    
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        if ((textField.text?.count)! <= maxLength) {
            return
        }
        
        let str = textField.text!
        let start = str.index(str.startIndex, offsetBy: 0)
        let end = str.index(str.endIndex, offsetBy: -1)
        textField.text = String(str[start..<end])
    }
    
    /**
     * 콤마형식의 값은 콤마제거 후 리턴
     */
    func getPrice() -> String {
        return self.text!.replacingOccurrences(of: ",", with: "")
    }
    
}

extension UIColor {
    
    /**
     * ColorCode #000000 또는 #00000000 형식으로 사용
     */
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
                    g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
                    b = CGFloat(hexNumber & 0x0000FF) / 255.0
                    a = 1.0
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

extension UIImage {
    
    func resizeImage(_ newSize: CGSize) -> UIImage? {
        func isSameSize(_ newSize: CGSize) -> Bool {
            return size == newSize
        }
        
        func scaleImage(_ newSize: CGSize) -> UIImage? {
            func getScaledRect(_ newSize: CGSize) -> CGRect {
                let ratio   = max(newSize.width / size.width, newSize.height / size.height)
                let width   = size.width * ratio
                let height  = size.height * ratio
                return CGRect(x: 0, y: 0, width: width, height: height)
            }
            
            func _scaleImage(_ scaledRect: CGRect) -> UIImage? {
                UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
                draw(in: scaledRect)
                let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
                return image
            }
            return _scaleImage(getScaledRect(newSize))
        }
        
        return isSameSize(newSize) ? self : scaleImage(newSize)!
    }
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

/**
 * NSDictionary를 android JsonObject 형식으로 사용
 */
extension NSDictionary {
    
    func getString(_ key: String) -> String {
        if (self.object(forKey: key) as? String != nil) {
            return String(self.object(forKey: key) as! String)
        }
        if (self.object(forKey: key) as? Int != nil) {
            return String(self.object(forKey: key) as! Int)
        }
        if (self.object(forKey: key) as? Float != nil) {
            return String(self.object(forKey: key) as! Float)
        }
        if (self.object(forKey: key) as? Double != nil) {
            return String(self.object(forKey: key) as! Double)
        }
        if (self.object(forKey: key) as? NSArray != nil) {
            return (self.object(forKey: key) as! NSArray).description
        }
        if (self.object(forKey: key) as? NSDictionary != nil) {
            return (self.object(forKey: key) as! NSDictionary).description
        }
        return ""
    }
    
    func getInt(_ key: String) -> Int {
        if (self.object(forKey: key) as? Int != nil) {
            return Int(self.object(forKey: key) as! Int)
        }
        if (self.object(forKey: key) as? String != nil) {
            return Int(self.object(forKey: key) as! String)!
        }
        return 0
    }
    
    func getDouble(_ key: String) -> Double {
        if (self.object(forKey: key) as? Double != nil) {
            return self.object(forKey: key) as! Double
        } else if (self.object(forKey: key) as? String != nil) {
            return Double(self.object(forKey: key) as! String)!
        }
        return 0.0
    }
    
    func getBoolean(_ key: String) -> Bool {
        if (self.object(forKey: key) as? Bool != nil) {
            return self.object(forKey: key) as! Bool
        }
        return false
    }
    
    func getJSONArray(_ key: String) -> NSArray {
        if (self.object(forKey: key) as? NSArray != nil) {
            return self.object(forKey: key) as! NSArray
        }
        return NSArray()
    }
    
    func getJSONObject(_ key: String) -> NSDictionary {
        if (self.object(forKey: key) as? NSDictionary != nil) {
            return self.object(forKey: key) as! NSDictionary
        }
        return NSDictionary()
    }
    
    func has(_ key: String) -> Bool {
        if (self.object(forKey: key) != nil) {
            return true
        }
        return false
    }
    
}

/**
 * NSArray를 android JsonArray 형식으로 사용
 */
extension NSArray {
    
    func getString(_ index: Int) -> String {
        if (self.object(at: index) as? String != nil) {
            return String(self.object(at: index) as! String)
        }
        if (self.object(at: index) as? Int != nil) {
            return String(self.object(at: index) as! Int)
        }
        if (self.object(at: index) as? Float != nil) {
            return String(self.object(at: index) as! Float)
        }
        if (self.object(at: index) as? Double != nil) {
            return String(self.object(at: index) as! Double)
        }
        if (self.object(at: index) as? NSArray != nil) {
            return (self.object(at: index) as! NSArray).description
        }
        if (self.object(at: index) as? NSDictionary != nil) {
            return (self.object(at: index) as! NSDictionary).description
        }
        return ""
    }
    
    func getInt(_ index: Int) -> Int {
        if (self.object(at: index) as? Int != nil) {
            return Int(self.object(at: index) as! Int)
        }
        if (self.object(at: index) as? Int != nil) {
            return Int(self.object(at: index) as! Int)
        }
        return 0
    }
    
    func getDouble(_ index: Int) -> Double {
        if (self.object(at: index) as? Double != nil) {
            return self.object(at: index) as! Double
        } else if (self.object(at: index) as? String != nil) {
            return Double(self.object(at: index) as! String)!
        }
        return 0.0
    }
    
    func getJSONArray(_ index: Int) -> NSArray {
        if (self.object(at: index) as? NSArray != nil) {
            return self.object(at: index) as! NSArray
        }
        return NSArray()
    }
    
    func getJSONObject(_ index: Int) -> NSDictionary {
        if (self.object(at: index) as? NSDictionary != nil) {
            return self.object(at: index) as! NSDictionary
        }
        return NSDictionary()
    }
    
}

extension NSLayoutConstraint {
    func setMultiplier(multiplier:CGFloat) {
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        newConstraint.isActive = true
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
    }
}
