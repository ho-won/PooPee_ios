//
//  SharedManager.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 6. 21..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation

final class SharedManager {

    // MARK: - Keys

    private static let LOGIN_CHECK = "LOGIN_CHECK" // 로그인체크
    private static let MEMBER_ID = "MEMBER_ID" // 멤버 아이디
    private static let MEMBER_USERNAME = "MEMBER_USERNAME" // 유저 아이디
    private static let MEMBER_PASSWORD = "MEMBER_PASSWORD" // 유저 비밀번호
    private static let MEMBER_NAME = "MEMBER_NAME" // 유저 닉네임
    private static let MEMBER_GENDER = "MEMBER_GENDER" // 유저 성별 1(남자) 2(여자)
    private static let DB_VER = "DB_VER" // toilet db 버전
    private static let NOTICE_DATE = "NOTICE_DATE" // 서버공지 다시보지않기 체크시간(Y-m-d)
    private static let NOTICE_IMAGE = "NOTICE_IMAGE" // 서버공지 이미지
    private static let LATITUDE = "LATITUDE" // latitude
    private static let LONGITUDE = "LONGITUDE" // longitude
    private static let PUSH = "PUSH" // 푸시알림
    private static let REVIEW_COUNT = "REVIEW_COUNT" // 리뷰팝업 조건
    private static let REWARD_EARNED_TIME = "REWARD_EARNED_TIME" // 리워드 24시간 체크
    private static let REWARD_POPUP_COUNT = "REWARD_POPUP_COUNT" // 리워드 유도 팝업 카운트

    private init() {}

    static var isLoginCheck: Bool {
        get { UserDefaults.standard.bool(forKey: LOGIN_CHECK) }
        set { UserDefaults.standard.set(newValue, forKey: LOGIN_CHECK) }
    }

    static var isPush: Bool {
        get { UserDefaults.standard.object(forKey: PUSH) != nil ? UserDefaults.standard.bool(forKey: PUSH) : false }
        set { UserDefaults.standard.set(newValue, forKey: PUSH) }
    }

    static var memberId: String {
        get { UserDefaults.standard.string(forKey: MEMBER_ID) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: MEMBER_ID) }
    }

    static var memberUsername: String {
        get { UserDefaults.standard.string(forKey: MEMBER_USERNAME) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: MEMBER_USERNAME) }
    }

    static var memberPassword: String {
        get { UserDefaults.standard.string(forKey: MEMBER_PASSWORD) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: MEMBER_PASSWORD) }
    }

    static var memberName: String {
        get { UserDefaults.standard.string(forKey: MEMBER_NAME) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: MEMBER_NAME) }
    }

    static var memberGender: String {
        get { UserDefaults.standard.string(forKey: MEMBER_GENDER) ?? "1" }
        set { UserDefaults.standard.set(newValue, forKey: MEMBER_GENDER) }
    }

    static var noticeDate: String {
        get { UserDefaults.standard.string(forKey: NOTICE_DATE) ?? "2000-01-01" }
        set { UserDefaults.standard.set(newValue, forKey: NOTICE_DATE) }
    }

    static var noticeImage: String {
        get { UserDefaults.standard.string(forKey: NOTICE_IMAGE) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: NOTICE_IMAGE) }
    }

    static var latitude: Double {
        get { UserDefaults.standard.object(forKey: LATITUDE) != nil ? UserDefaults.standard.double(forKey: LATITUDE) : 0.0 }
        set { UserDefaults.standard.set(newValue, forKey: LATITUDE) }
    }

    static var longitude: Double {
        get { UserDefaults.standard.object(forKey: LONGITUDE) != nil ? UserDefaults.standard.double(forKey: LONGITUDE) : 0.0 }
        set { UserDefaults.standard.set(newValue, forKey: LONGITUDE) }
    }

    static var dbVer: Int {
        get { UserDefaults.standard.integer(forKey: DB_VER) }
        set { UserDefaults.standard.set(newValue, forKey: DB_VER) }
    }

    static var reviewCount: Int {
        get { UserDefaults.standard.integer(forKey: REVIEW_COUNT) }
        set { UserDefaults.standard.set(newValue, forKey: REVIEW_COUNT) }
    }
    
    static var rewardEarnedTime: Double {
        get { UserDefaults.standard.object(forKey: REWARD_EARNED_TIME) != nil ? UserDefaults.standard.double(forKey: REWARD_EARNED_TIME) : 0 }
        set { UserDefaults.standard.set(newValue, forKey: REWARD_EARNED_TIME) }
    }
    
    static var rewardPopupCount: Int {
        get { UserDefaults.standard.integer(forKey: REWARD_POPUP_COUNT) }
        set { UserDefaults.standard.set(newValue, forKey: REWARD_POPUP_COUNT) }
    }
}
