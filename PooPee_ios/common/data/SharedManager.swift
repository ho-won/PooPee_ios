//
//  SharedManager.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 6. 21..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation

class SharedManager {
    static let instance = SharedManager()
    
    let LOGIN = "LOGIN"
    let LOGIN_CHECK = "LOGIN_CHECK" // 로그인체크
    
    let MEMBER = "MEMBER"
    let MEMBER_ID = "MEMBER_ID" // 멤버 아이디
    let MEMBER_USERNAME = "MEMBER_USERNAME" // 유저 아이디
    let MEMBER_PASSWORD = "MEMBER_PASSWORD" // 유저 비밀번호
    let MEMBER_NAME = "MEMBER_NAME" // 유저 닉네임
    let MEMBER_GENDER = "MEMBER_GENDER" // 유저 성별 1(남자) 2(여자)
    
    let ETC = "ETC"
    let DB_VER = "DB_VER" // toilet db 버전
    let NOTICE_DATE = "NOTICE_DATE" // 서버공지 다시보지않기 체크시간(Y-m-d)
    let NOTICE_IMAGE = "NOTICE_IMAGE" // 서버공지 이미지
    let LATITUDE = "LATITUDE" // latitude
    let LONGITUDE = "LONGITUDE" // longitude
    let PUSH = "PUSH" // 푸시알림
    
    private init() {
        
    }
    
    func isLoginCheck() -> Bool {
        if (UserDefaults.standard.object(forKey: LOGIN_CHECK) != nil) {
            return UserDefaults.standard.bool(forKey: LOGIN_CHECK)
        } else {
            return false
        }
    }
    
    func setLoginCheck(value: Bool) {
        UserDefaults.standard.set(value, forKey: LOGIN_CHECK)
    }
    
    func getMemberId() -> String {
        if (UserDefaults.standard.object(forKey: MEMBER_ID) != nil) {
            return UserDefaults.standard.string(forKey: MEMBER_ID)!
        } else {
            return ""
        }
    }
    
    func setMemberId(value: String) {
        UserDefaults.standard.set(value, forKey: MEMBER_ID)
    }
    
    func getMemberUsername() -> String {
        if (UserDefaults.standard.object(forKey: MEMBER_USERNAME) != nil) {
            return UserDefaults.standard.string(forKey: MEMBER_USERNAME)!
        } else {
            return ""
        }
    }
    
    func setMemberUsername(value: String) {
        UserDefaults.standard.set(value, forKey: MEMBER_USERNAME)
    }
    
    func getMemberPassword() -> String {
        if (UserDefaults.standard.object(forKey: MEMBER_PASSWORD) != nil) {
            return UserDefaults.standard.string(forKey: MEMBER_PASSWORD)!
        } else {
            return ""
        }
    }
    
    func setMemberPassword(value: String) {
        UserDefaults.standard.set(value, forKey: MEMBER_PASSWORD)
    }
    
    func getMemberName() -> String {
        if (UserDefaults.standard.object(forKey: MEMBER_NAME) != nil) {
            return UserDefaults.standard.string(forKey: MEMBER_NAME)!
        } else {
            return ""
        }
    }
    
    func setMemberName(value: String) {
        UserDefaults.standard.set(value, forKey: MEMBER_NAME)
    }
    
    func getMemberGender() -> String {
        if (UserDefaults.standard.object(forKey: MEMBER_GENDER) != nil) {
            return UserDefaults.standard.string(forKey: MEMBER_GENDER)!
        } else {
            return "1"
        }
    }
    
    func setMemberGender(value: String) {
        UserDefaults.standard.set(value, forKey: MEMBER_GENDER)
    }
    
    func getDbVer() -> Int {
        if (UserDefaults.standard.object(forKey: DB_VER) != nil) {
            return UserDefaults.standard.integer(forKey: DB_VER)
        } else {
            return 0
        }
    }
    
    func setDbVer(value: Int) {
        UserDefaults.standard.set(value, forKey: DB_VER)
    }
    
    func getNoticeDate() -> String {
        if (UserDefaults.standard.object(forKey: NOTICE_DATE) != nil) {
            return UserDefaults.standard.string(forKey: NOTICE_DATE)!
        } else {
            return "2000-01-01"
        }
    }
    
    func setNoticeDate(value: String) {
        UserDefaults.standard.set(value, forKey: NOTICE_DATE)
    }
    
    func getNoticeImage() -> String {
        if (UserDefaults.standard.object(forKey: NOTICE_IMAGE) != nil) {
            return UserDefaults.standard.string(forKey: NOTICE_IMAGE)!
        } else {
            return ""
        }
    }
    
    func setNoticeImage(value: String) {
        UserDefaults.standard.set(value, forKey: NOTICE_IMAGE)
    }
    
    func getLatitude() -> Double {
        if (UserDefaults.standard.object(forKey: LATITUDE) != nil) {
            return UserDefaults.standard.double(forKey: LATITUDE)
        } else {
            return 0.0
        }
    }
    
    func setLatitude(value: Double) {
        UserDefaults.standard.set(value, forKey: LATITUDE)
    }
    
    func getLongitude() -> Double {
        if (UserDefaults.standard.object(forKey: LONGITUDE) != nil) {
            return UserDefaults.standard.double(forKey: LONGITUDE)
        } else {
            return 0.0
        }
    }
    
    func setLongitude(value: Double) {
        UserDefaults.standard.set(value, forKey: LONGITUDE)
    }
    
    func isPush() -> Bool {
        if (UserDefaults.standard.object(forKey: PUSH) != nil) {
            return UserDefaults.standard.bool(forKey: PUSH)
        } else {
            return false
        }
    }
    
    func setPush(value: Bool) {
        UserDefaults.standard.set(value, forKey: PUSH)
    }
    
}
