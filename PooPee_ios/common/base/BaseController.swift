//
//  BaseController.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 6. 21..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit

public class BaseController: UIViewController {
    var indicator: UIActivityIndicatorView! = nil
    var segueData = SegueData() // 현재 SegueData (getIntent 용도)
    var resultSegueData = SegueData() // 안드로이드의 onActivityResult 용도
    var isViewDidAppear = false // viewDidAppear 두번호출 방지
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if (ObserverManager.root != nil) {
            ObserverManager.preRoot = ObserverManager.root
        }
        ObserverManager.root = self
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if (ObserverManager.root != nil && ObserverManager.root.resultSegueData.resultCode == SegueData.RESULT_OK) {
            onControllerResult(requestCode: ObserverManager.root.resultSegueData.requestCode, data: ObserverManager.root.resultSegueData)
        }
        ObserverManager.root = self
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .default // .lightContent
    }
    
    /*
     * statusbar 컬러변경
     */
    public func setStatusColor(color: UIColor) {
        let statusBarView = UIView()
        statusBarView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: UIApplication.shared.statusBarFrame.height)
        statusBarView.backgroundColor = color
        statusBarView.layer.zPosition = -1
        view.addSubview(statusBarView)
    }
    
    /*
     * 부모 컨트롤러
     */
    public func getParentController() -> BaseController {
        return self.presentingViewController as! BaseController
    }
    
    /*
     * indicator show
     */
    public func showLoading() {
        if (indicator != nil) {
            indicator.removeFromSuperview()
        }
        
        indicator = UIActivityIndicatorView()
        indicator.color = colors.primary
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 60, height: 60)
        indicator.center = view.center
        indicator.startAnimating()
        indicator.isHidden = false
        
        view.addSubview(indicator)
        view.isUserInteractionEnabled = false
    }
    
    /*
     * indicator hide
     */
    public func hideLoading() {
        if (indicator != nil) {
            indicator.isHidden = true
            indicator.stopAnimating()
        }
        view.isUserInteractionEnabled = true
    }
    
    /*
     * indicator show check
     */
    public func isShowLoading() -> Bool {
        if (indicator != nil && indicator.isHidden == false){
            return true
        } else {
            return false
        }
    }
    
    /*
     * 홈버튼
     */
    func setHomeButton(btn_home: UIButton) {
        btn_home.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btn_home_tap(recognizer:))))
    }
    
    /*
     * 홈버튼 클릭시 HomeController 이동
     */
    @objc private func btn_home_tap(recognizer: UITapGestureRecognizer) {
        if (ObserverManager.root == nil) {
            return
        }
        var currentController = ObserverManager.root!
        currentController.dismiss(animated: false, completion: nil)
        while let presentedController: BaseController = currentController.presentingViewController as? BaseController {
            currentController = presentedController
            if (NSStringFromClass(currentController.classForCoder) == "cardealerpro.HomeController") {
                break
            } else {
                DispatchQueue.main.async {
                    currentController.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    /*
     * 컨트롤러 present (right to left 애니메이션 추가)
     */
    func startPresent(controller: BaseController) {
        if let window = UIApplication.shared.delegate?.window!, let rootViewController = window.rootViewController {
            var currentController = rootViewController
            while let presentedController = currentController.presentedViewController {
                currentController = presentedController
            }
            
            let src = currentController // 현재 컨트롤러
            let dst = controller // 불러올 컨트롤러
            
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
    
    /*
     * 컨트롤러 present (right to left 애니메이션 추가)
     */
    func startPresent(controller: BaseController, parent: BaseController) {
        if let window = UIApplication.shared.delegate?.window!, let rootViewController = window.rootViewController {
            var currentController = rootViewController
            while let presentedController = currentController.presentedViewController {
                currentController = presentedController
            }
            
            let src = currentController // 현재 컨트롤러
            let dst = controller // 불러올 컨트롤러
            
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
                            parent.present(dst, animated: false, completion: nil)
            }
            )
        }
    }
    
    /*
     * 컨트롤러 종료
     */
    public func finish() {
        ObserverManager.preRoot = ObserverManager.root
        
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    /*
     * 컨트롤러 종료
     */
    public func finishFromRight() {
        ObserverManager.preRoot = ObserverManager.root
        
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func onControllerResult(requestCode: Int, data: SegueData) {
        
    }
    
    func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    
    func onLocationChanged() {
        
    }
    
}
