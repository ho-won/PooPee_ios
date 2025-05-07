//
//  ToiletHeaderView.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/10/28.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import GoogleMobileAds
import KakaoMapsSDK
import WebKit

class ToiletHeaderCell: UITableViewCell, MapControllerDelegate, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet var root_view: UIView!
    
    @IBOutlet var map_view: KMViewContainer!
    @IBOutlet var map_view_click: UIView!
    
    @IBOutlet var tv_toilet_name: MyLabel!
    @IBOutlet var tv_toilet_content: MyLabel!
    
    @IBOutlet var layout_btn_normal: UIView!
    @IBOutlet var layout_like: bg_layout_like!
    @IBOutlet var cb_like: btn_like!
    @IBOutlet var tv_like: UILabel!
    @IBOutlet var layout_report: bg_layout_like!
    @IBOutlet var tv_report: UILabel!
    
    @IBOutlet var layout_btn_mine: UIView!
    @IBOutlet var layout_delete: bg_layout_like!
    @IBOutlet var tv_delete: UILabel!
    @IBOutlet var layout_update: bg_layout_like!
    @IBOutlet var tv_update: UILabel!
    
    @IBOutlet var tv_address: UILabel!
    @IBOutlet var cb_tap_address: cb_up_down!
    
    @IBOutlet var cb_option_01: cb_option_01!
    @IBOutlet var cb_option_02: cb_option_02!
    @IBOutlet var cb_option_03: cb_option_03!
    @IBOutlet var cb_option_04: cb_option_04!
    @IBOutlet var cb_option_05: cb_option_05!
    @IBOutlet var cb_option_06: cb_option_06!
    
    @IBOutlet var layout_detail_icon: UIView!
    @IBOutlet var layout_detail_address: UIView!
    
    @IBOutlet var tv_m: UILabel!
    @IBOutlet var tv_m_poo_title: UILabel!
    @IBOutlet var tv_m_poo: UILabel!
    @IBOutlet var tv_m_pee_title: UILabel!
    @IBOutlet var tv_m_pee: UILabel!
    @IBOutlet var tv_m_d_poo_title: UILabel!
    @IBOutlet var tv_m_d_poo: UILabel!
    @IBOutlet var tv_m_d_pee_title: UILabel!
    @IBOutlet var tv_m_d_pee: UILabel!
    @IBOutlet var tv_m_c_poo_title: UILabel!
    @IBOutlet var tv_m_c_poo: UILabel!
    @IBOutlet var tv_m_c_pee_title: UILabel!
    @IBOutlet var tv_m_c_pee: UILabel!
    
    @IBOutlet var tv_w: UILabel!
    @IBOutlet var tv_w_poo_title: UILabel!
    @IBOutlet var tv_w_poo: UILabel!
    @IBOutlet var tv_w_d_poo_title: UILabel!
    @IBOutlet var tv_w_d_poo: UILabel!
    @IBOutlet var tv_w_c_poo_title: UILabel!
    @IBOutlet var tv_w_c_poo: UILabel!
    
    @IBOutlet var web_view: WKWebView!
    
    @IBOutlet var tv_manager: UILabel!
    @IBOutlet var cb_tap_manager: cb_up_down!
    
    @IBOutlet var layout_detail_manager_title: UIView!
    @IBOutlet var layout_detail_manager: UIView!
    @IBOutlet var tv_manager_name_title: UILabel!
    @IBOutlet var tv_manager_name: UILabel!
    @IBOutlet var tv_manager_tel_title: UILabel!
    @IBOutlet var tv_manager_tel: UILabel!
    @IBOutlet var tv_open_time_title: UILabel!
    @IBOutlet var tv_open_time: UILabel!
    
    @IBOutlet var tv_comment: UILabel!
    @IBOutlet var tv_comment_count: UILabel!
    @IBOutlet var btn_comment: UIButton!
    
    var kakaoMap: KakaoMap?
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        kakaoMap = MTMapView(frame: map_view.bounds)
//        kakaoMap.setZoomLevel(2, animated: true)
//        
//        kakaoMap.baseMapType = .standard
//        map_view.addSubview(kakaoMap)
        
        tv_like.text = "0"
        tv_report.text = "toilet_btn_01".localized
        tv_delete.text = "toilet_btn_02".localized
        tv_update.text = "toilet_btn_03".localized
        
        tv_m.text = "toilet_option_01".localized
        tv_m_poo_title.text = "toilet_option_03".localized
        tv_m_pee_title.text = "toilet_option_04".localized
        tv_m_d_poo_title.text = "toilet_option_05".localized
        tv_m_d_pee_title.text = "toilet_option_06".localized
        tv_m_c_poo_title.text = "toilet_option_07".localized
        tv_m_c_pee_title.text = "toilet_option_08".localized
        
        tv_w.text = "toilet_option_02".localized
        tv_w_poo_title.text = "toilet_option_03".localized
        tv_w_d_poo_title.text = "toilet_option_05".localized
        tv_w_c_poo_title.text = "toilet_option_07".localized
        
        tv_manager.text = "home_text_10".localized
        tv_manager_name_title.text = "toilet_option_10".localized
        tv_manager_tel_title.text = "toilet_option_11".localized
        tv_open_time_title.text = "toilet_option_12".localized
        
        tv_comment.text = "home_text_03".localized
        
        cb_tap_address.setSelected(selected: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mapController = KMController(viewContainer: self.map_view)
            self.mapController?.delegate = self
            self.mapController?.prepareEngine()
            self.mapController?.activateEngine()
        }
        
        setCoupangAd()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addPOIItem(toilet: Toilet) {
        if (kakaoMap != nil) {
            if (toilet.toilet_id < 0) {
                let image = UIImage(named: "ic_position_up")!.imageResize(sizeChange: CGSize(width: 14, height: 16))
                
                let iconStyle = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1))
                let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
                let poiStyle = PoiStyle(styleID: "toilet_up", styles: [perLevelStyle])
                kakaoMap!.getLabelManager().addPoiStyle(poiStyle)
                
                let poiOption = PoiOptions(styleID: "toilet_up", poiID: String(toilet.toilet_id))
                poiOption.rank = 0
                poiOption.clickable = true
                let poi = kakaoMap!.getLabelManager().getLabelLayer(layerID: "toilet")?.addPoi(option: poiOption, at: MapPoint(longitude: toilet.longitude, latitude: toilet.latitude))
                poi?.show()
            } else {
                let image = UIImage(named: "ic_position")!.imageResize(sizeChange: CGSize(width: 14, height: 16))
                
                let iconStyle = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1))
                let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
                let poiStyle = PoiStyle(styleID: "toilet", styles: [perLevelStyle])
                kakaoMap!.getLabelManager().addPoiStyle(poiStyle)
                
                let poiOption = PoiOptions(styleID: "toilet", poiID: String(toilet.toilet_id))
                poiOption.rank = 0
                poiOption.clickable = true
                let poi = kakaoMap!.getLabelManager().getLabelLayer(layerID: "toilet")?.addPoi(option: poiOption, at: MapPoint(longitude: toilet.longitude, latitude: toilet.latitude))
                poi?.show()
            }
        }
    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            LogManager.e("지도 종료(API인증 파라미터 오류)")
            break;
        case 401:
            LogManager.e("지도 종료(API인증 키 오류)")
            break;
        case 403:
            LogManager.e("지도 종료(API인증 권한 오류)")
            break;
        case 429:
            LogManager.e("지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            LogManager.e("지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break;
        default:
            break;
        }
    }
    
    func addViews() {
        let defaultPosition = MapPoint(longitude: ObserverManager.currentToilet.longitude, latitude: ObserverManager.currentToilet.latitude)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: ObserverManager.BASE_ZOOM_LEVEL)
        
        mapController?.addView(mapviewInfo)
    }

    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        kakaoMap = mapController?.getView("mapview") as? KakaoMap
        if (kakaoMap != nil) {
            let _ = kakaoMap!.getLabelManager().addLabelLayer(option: LabelLayerOptions(layerID: "toilet", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001))
            addPOIItem(toilet: ObserverManager.currentToilet)
        }
    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
    
    func setCoupangAd() {
        web_view.navigationDelegate = self
        web_view.uiDelegate = self
        
        // HTML 삽입
        let htmlData = """
                <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <script src="https://ads-partners.coupang.com/g.js"></script>
                </head>
                <body style="margin:0;padding:0;display:flex;justify-content:center;align-items:center;">
                    <script>
                        new PartnersCoupang.G({
                            "id": 846359,
                            "template": "carousel",
                            "trackingCode": "AF3689916",
                            "width": "360",
                            "height": "60",
                            "tsource": ""
                        });
                    </script>
                </body>
                </html>
                """
        
        web_view.loadHTMLString(htmlData, baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           navigationAction.navigationType == .linkActivated {
            // 광고 클릭 시 외부 브라우저로 열기
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil || !(navigationAction.targetFrame?.isMainFrame ?? false) {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url)
            }
        }
        return nil
    }
    
}
