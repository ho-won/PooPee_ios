//
//  StrManager.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 8..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit

class StrManager {
    private static let SEC = 60
    private static let MIN = 60
    private static let HOUR = 24
    private static let DAY = 90
    
    /**
     * 숫자형식의 텍스트를 콤마 형식으로 변경
     * ex) 1000 -> 1,000
     */
    static func getComma(str: String) -> String {
        if (str == "") {
            return "-"
        }
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.groupingSize = 3
        
        return decimalFormatter.string(from: Int(str)! as NSNumber)!
    }
    
    /**
     * date string을 현재시간기준으로 분/시/일/월
     */
    static func getCalculateTime(str: String) -> String {
        let format = DateFormatter()
        format.dateFormat  = "yyyy-MM-dd HH:mm"
        let date = format.date(from: str)
        
        if (date != nil) {
            let currentDate = Date()
            var diffTime = Int(currentDate.timeIntervalSince(date!))
            
            if (diffTime / SEC < MIN) {
                return String(diffTime / SEC) + "분전"
            }
            
            diffTime = diffTime / SEC
            if (diffTime / MIN < HOUR) {
                return String(diffTime / MIN) + "시간전"
            }
            
            diffTime = diffTime / MIN
            if (diffTime / HOUR < DAY) {
                return String(diffTime / HOUR) + "일전"
            }
            
            diffTime = diffTime / HOUR
            return String(Int(diffTime / 30)) + "개월 이상"
        }
        return str
    }
    
    /**
     * date string을 현재시간기준으로 남은 일수 계산
     */
    static func getEndDays(date: String) -> String {
        let format = DateFormatter()
        format.dateFormat  = "yyyy-MM-dd"
        
        let interval = format.date(from: date)!.timeIntervalSinceNow
        let days = Int(interval / 86400)
        return String(days)
    }
    
    static func getDateTime(str: String) -> String {
        let format = DateFormatter()
        format.dateFormat  = "yyyy-MM-dd HH:mm:ss"
        let date = format.date(from: str)!
        
        let newFormat = DateFormatter()
        newFormat.dateFormat  = "yyyy.MM.dd HH:mm"
        return format.string(from: date)
    }
    
    static func getCurrentDate() -> String {
        let format = DateFormatter()
        format.dateFormat  = "yyyy-MM-dd"
        return format.string(from: Date())
    }
    
    static func setAddressCopySpan(tv_address: UILabel, addressText: String) {
        let fullString = NSMutableAttributedString(string: addressText + " ")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "ic_copy")
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 14)
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        tv_address.attributedText = fullString
        tv_address.setOnClickListener {
            UIPasteboard.general.string = addressText
            ObserverManager.root.view.makeToast(message: "toast_copy_complete".localized)
        }
    }
    
}
