//
//  MyDateFormat.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 8..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation

class MyDateFormat {
    
    static func getDate(format: DateFormatter, date: Date) -> String {
        return format.string(from: date)
    }
    
    static func getCurrentDate(format: DateFormatter) -> String {
        let currentDate = Date()
        return format.string(from: currentDate)
    }
    
    static var datetime: DateFormatter {
        get {
            let format = DateFormatter()
            format.dateFormat  = "yyyy-MM-dd HH:mm"
            return format
        }
    }
    
    static var date: DateFormatter {
        get {
            let format = DateFormatter()
            format.dateFormat  = "yyyy.MM.dd"
            return format
        }
    }
    
    static var dateInt: DateFormatter {
        get {
            let format = DateFormatter()
            format.dateFormat  = "yyyyMMdd"
            return format
        }
    }
    
    static var y_m: DateFormatter {
        get {
            let format = DateFormatter()
            format.dateFormat  = "yyyy.MM"
            return format
        }
    }
    
    static var year: DateFormatter {
        get {
            let format = DateFormatter()
            format.dateFormat  = "yyyy"
            return format
        }
    }
    
    static var month: DateFormatter {
        get {
            let format = DateFormatter()
            format.dateFormat  = "MM"
            return format
        }
    }
    
    static var m_d: DateFormatter {
        get {
            let format = DateFormatter()
            format.dateFormat  = "MM/dd"
            return format
        }
    }
    
    static var d: DateFormatter {
        get {
            let format = DateFormatter()
            format.dateFormat  = "dd"
            return format
        }
    }
    
}
