//
//  CopyController.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 8..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit
import Alamofire

class MaskController: BaseController, UIWebViewDelegate {
    @IBOutlet var web_view: UIWebView!
    @IBOutlet var layout_alpha: UIView!
    
    @IBOutlet var layout_input: UIView!
    @IBOutlet var edt_url: UITextField!
    @IBOutlet var btn_search: UIButton!
    @IBOutlet var btn_refresh: UIButton!
    @IBOutlet var btn_back: UIButton!
    @IBOutlet var btn_position: UIButton!
    @IBOutlet var btn_start: UIButton!
    
    var currentLocation: CGPoint! = nil
    var currentColorCode: String = ""
    
    var isStart: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        
        _init()
        setListener()
    }
    
    func _init() {
        loadCookie()
        
        web_view.scrollView.bounces = false
        web_view.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        
        // 쿠키가 저장 안되는 문제 해결
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        web_view.delegate = self
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        btn_search.setOnClickListener {
            self.web_view.loadRequest(URLRequest(url: URL(string: self.edt_url.text!)!))
            self.layout_input.isHidden = true
            self.view.endEditing(true)
        }
        layout_alpha.setOnClickListener {
            self.layout_alpha.isHidden = true
        }
        btn_refresh.setOnClickListener {
            self.web_view.reload()
        }
        btn_back.setOnClickListener {
            if (self.web_view.canGoBack) {
                self.web_view.goBack()
            } else {
                self.finish()
            }
        }
        btn_position.setOnClickListener {
            self.layout_alpha.isHidden = false
        }
        btn_start.setOnClickListener {
            self.isStart = true
            self.checkBuy()
        }
    }
    
    func checkBuy() {
        if (!isStart || currentLocation == nil) {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let color = self.getPixelColorAtPoint(point: self.currentLocation, sourceView: self.web_view)
            if (self.currentColorCode == color.toHexString()) {
                self.web_view.reload()
            } else {
                self.isStart = false
            }
            print("color : \(color.toHexString())")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!layout_alpha.isHidden){
            let touch = touches.first!
            currentLocation = touch.location(in: layout_alpha)
            let color = getPixelColorAtPoint(point: currentLocation, sourceView: web_view)
            currentColorCode = color.toHexString()
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        showLoading()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        saveCookie()
        hideLoading()
        checkBuy()
    }
    
    func saveCookie() {
        let cookieJar: HTTPCookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieJar.cookies {
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: cookies)
            let ud: UserDefaults = UserDefaults.standard
            ud.set(data, forKey: "cookie")
        }
    }

    func loadCookie() {
        let ud: UserDefaults = UserDefaults.standard
        let data: Data? = ud.object(forKey: "cookie") as? Data
        if let cookie = data {
            let datas: NSArray? = NSKeyedUnarchiver.unarchiveObject(with: cookie) as? NSArray
            if let cookies = datas {
                for c in cookies {
                    if let cookieObject = c as? HTTPCookie {
                        HTTPCookieStorage.shared.setCookie(cookieObject)
                    }
                }
            }
        }
    }
    
    func getPixelColorAtPoint(point:CGPoint, sourceView: UIView) -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        var color: UIColor? = nil

        if let context = context {
            context.translateBy(x: -point.x, y: -point.y)
            sourceView.layer.render(in: context)

            color = UIColor(red: CGFloat(pixel[0])/255.0,
                            green: CGFloat(pixel[1])/255.0,
                            blue: CGFloat(pixel[2])/255.0,
                            alpha: CGFloat(pixel[3])/255.0)

            pixel.deallocate()
        }
        return color!
    }
    
}

extension UIColor {
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
