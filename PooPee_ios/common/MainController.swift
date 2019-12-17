//
//  MainController.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 6. 21..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class MainController: BaseController {
    @IBOutlet var layout_drop: UIView!
    @IBOutlet var iv_drop: UIImageView!
    @IBOutlet var iv_drop_top: NSLayoutConstraint!
    @IBOutlet var progress_file_download: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _init()
    }
    
    func _init() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5, delay: 0, options: [],
                           animations: {
                            self.iv_drop_top.constant = self.layout_drop.frame.height + 4
                            self.layout_drop.layoutIfNeeded()
            }, completion: { finished in
                UIView.animate(withDuration: 0.25, delay: 0, options: [],
                               animations: {
                                self.iv_drop_top.constant = self.layout_drop.frame.height
                                self.layout_drop.layoutIfNeeded()
                }, completion: { finished in
                    self.onServiceCheck()
                })
            })
        }
    }
    
    func onServiceCheck() {
        _ = DBVersionTask(progress: progress_file_download,
                          onSuccess: {
                            self.taskServerCheck()
        },
                          onFalied: {
                            let alert = UIAlertController(title: nil, message: "dialog_download_request".localized, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
                                self.finish()
                            }))
                            self.present(alert, animated: true, completion: nil)
        })
    }
    
    /**
     * 서버의 앱버전정보와 현재 앱버전정보를 비교하여 팝업창 띄움.
     *
     * @param response server version data.
     */
    func onVersionCheck(response: NSDictionary) {
        let version = response.getString("version_ios");
        let versions = version.components(separatedBy: ".")
        let appVersions = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String).components(separatedBy: ".")
        
        if (Int(versions[0])! > Int(appVersions[0])!) {
            // 첫번째 자리 버전 업데이트로 무조건 업데이트받아야 앱 실행
            let alert = UIAlertController(title: nil, message: "dialog_force_new_version_update".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
                self.updateInPlayMarket()
            }))
            alert.addAction(UIAlertAction(title: "no".localized, style: .cancel, handler: { action in
                exit(0)
            }))
            self.present(alert, animated: true, completion: nil)
        } else if (Int(versions[0])! < Int(appVersions[0])!) {
            // 세번째 자리 버전 업데이트로 무시하고 앱실행
            loginCheck();
        } else if (Int(versions[1])! > Int(appVersions[1])!) {
            // 두번째 자리 버전 업데이트로 업데이트 팝업 선택 후 앱 실행
            let alert = UIAlertController(title: nil, message: "dialog_assign_new_version_update".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
                self.updateInPlayMarket()
                exit(0)
            }))
            alert.addAction(UIAlertAction(title: "no".localized, style: .cancel, handler: { action in
                self.loginCheck()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            // 현재 앱버전이 최신버전일경우
            loginCheck()
        }
    }
    
    /**
     * 앱의 스토어로 이동.
     */
    func updateInPlayMarket() {
        // let appStoreLink = "https://itunes.apple.com/app/id\(APPLE_ID)?action=write-review" // 앱 스토어의 리뷰화면으로 바로이동
        let appStoreLink = "https://itunes.apple.com/app/id\(ObserverManager.APPLE_ID)"
        UIApplication.shared.open(URL(string: appStoreLink)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    /**
     * 자동로그인 체크.
     */
    func loginCheck() {
        if (SharedManager.instance.isLoginCheck()) {
            taskLogin()
        } else {
            gotoHome()
        }
    }
    
    /**
     * 자동로그인 체크.
     */
    func gotoHome() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let controller = ObserverManager.getController(name: "HomeController")
            self.startPresent(controller: controller)
        }
    }
    
    /**
     * [GET] 로그인
     */
    func taskLogin() {
        var params: Parameters = Parameters()
        params.put("username", SharedManager.instance.getMemberUsername())
        params.put("password", SharedManager.instance.getMemberPassword())
        params.put("pushkey", "test")
        params.put("os", "ios")
        
        BaseTask().request(url: NetDefine.LOGIN, method: .post, params: params
            , onSuccess: { response in
                if (response.getInt("rst_code") == 0) {
                    SharedManager.instance.setMemberId(value: response.getString("member_id"))
                    SharedManager.instance.setMemberName(value: response.getString("name"))
                    SharedManager.instance.setMemberGender(value: response.getString("gender"))
                    self.gotoHome()
                } else {
                    ObserverManager.logout()
                    self.gotoHome()
                }
        }
            , onFailed: { statusCode in
                ObserverManager.logout()
                self.gotoHome()
        })
    }
    
    /**
     * [GET] 서버상태체크
     */
    func taskServerCheck() {
        var params: Parameters = Parameters()
        params.put("date", SharedManager.instance.getNoticeDate())
        
        BaseTask().request(url: NetDefine.SERVER_CHECK, method: .get, params: params
            , onSuccess: { response in
                if (response.getInt("rst_code") == 0) {
                    SharedManager.instance.setNoticeImage(value: response.getString("notice_image"))
                    self.onVersionCheck(response: response); // 버전체크
                } else {
                    self.view.makeToast(message: "toast_checking_service")
                    self.finish()
                }
        }
            , onFailed: { statusCode in
                self.view.makeToast(message: "toast_checking_service")
                self.finish()
        })
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
