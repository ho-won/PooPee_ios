//
//  NetDefine.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 6. 21..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation

struct NetDefine {
    static let NETWORK_TIMEOUT = 30000;
    
    static let BASE_APP = ObserverManager.isTestServer() ? "http://49.236.137.205/PooPee_server/" : "http://49.236.137.205/PooPee_server/"
    
    static let TEST_API = "test" // test
    static let DB_CHECK = "etcs/dbCheck" // [GET] toilet db 버전체크
    static let SERVER_CHECK = "etcs/serverCheck" // [GET] 서버상태체크
    static let LOGIN = "members/login" // [POST] 로그인
    static let JOIN = "members/join" // [POST] 회원가입
    static let USER_UPDATE = "members/updateUser" // [PUT] 회원정보수정
    static let OVER_LAP = "members/getOverlap" // [GET] 아이디 중복체크
    static let NOTICE_LIST = "notices/getNoticeList" // [GET] 공지사항목록
    static let TOILET_INFO = "toilets/getToiletInfo" // [GET] 화장실 정보
    static let TOILET_LIKE = "toiletLikes/setToiletLike" // [POST] 좋아요
    static let COMMENT_LIST = "comments/getCommentList" // [GET] 댓글목록
    static let COMMENT_CREATE = "comments/createComment" // [POST] 댓글작성
    static let COMMENT_DELETE = "comments/deleteComment" // [DELETE] 댓글삭제
    static let COMMENT_UPDATE = "comments/updateComment" // [PUT] 댓글수정
    static let COMMENT_REPORT_CREATE = "commentReports/createReport" // [POST] 댓글신고
    
    static let TERMS_01 = "etcs/getTerms01" // 개인정보 처리방침
    static let TERMS_02 = "etcs/getTerms02" // 서비스 이용약관
    static let TERMS_03 = "etcs/getTerms03" // 위치정보기반 서비스 이용약관
    
    static let KAKAO_API_KEY = "dff7010c98c6542a9977f13c10d71a91"
    static let KAKAO_LOCAL_SEARCH = "https://dapi.kakao.com/v2/local/search/keyword.json" // 카카오지도 키워드 검색
    static let KAKAO_COORD_TO_ADDRESS = "https://dapi.kakao.com/v2/local/geo/coord2address.json" // 카카오 좌표 -> 주소 변환
    
}
