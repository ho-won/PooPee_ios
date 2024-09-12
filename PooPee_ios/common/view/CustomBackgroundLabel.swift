//
//  CustomBackgroundLabel.swift
//  PooPee_ios
//
//  Created by ho1 on 9/6/24.
//  Copyright © 2024 ho1. All rights reserved.
//

import UIKit

class CustomBackgroundLabel: UIView {

    // 외부에서 변경 가능한 텍스트 속성
    var text: String = "This is a custom background example." {
        didSet {
            // 텍스트가 변경되면 뷰를 다시 그리도록 함
            setNeedsDisplay()
        }
    }
    
    var highlightedRange: NSRange = NSRange(location: 10, length: 6) {
        didSet {
            // 하이라이트 범위가 변경되면 다시 그리기
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.backgroundColor = UIColor(hex: "#f2f6ff")!
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 텍스트의 속성 설정
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor(hex: "#f2f6ff")!
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        // 텍스트 전체의 크기를 계산
        let textSize = attributedText.size()
        let textRect = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        // 하이라이트된 텍스트 부분의 백그라운드 하단 1/3을 칠하기
        let startX = textRect.origin.x
        let highlightedTextSize = (attributedText.string as NSString).substring(with: highlightedRange).size(withAttributes: attributes)
        let highlightedRect = CGRect(x: startX + highlightedTextSize.width / 3, y: textRect.height * 2 / 3, width: highlightedTextSize.width, height: textRect.height / 3)
        
        context.setFillColor(UIColor.yellow.cgColor)
        context.fill(highlightedRect)
        
        // 텍스트 그리기
        attributedText.draw(in: textRect)
    }
}

//// ViewController에서 사용하는 방법
//class ViewController: UIViewController {
//    
//    var customLabel: CustomBackgroundLabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        customLabel = CustomBackgroundLabel()
//        customLabel.translatesAutoresizingMaskIntoConstraints = false
//        customLabel.backgroundColor = .clear
//        
//        self.view.addSubview(customLabel)
//        
//        // 제약 조건 설정
//        NSLayoutConstraint.activate([
//            customLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            customLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            customLabel.widthAnchor.constraint(equalToConstant: 300),
//            customLabel.heightAnchor.constraint(equalToConstant: 100)
//        ])
//        
//        // 초기 텍스트 설정
//        customLabel.text = "Initial text here."
//        
//        // 몇 초 후 텍스트 변경 (예시)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.customLabel.text = "Updated text with a new background."
//            self.customLabel.highlightedRange = NSRange(location: 8, length: 10)
//        }
//    }
//}

