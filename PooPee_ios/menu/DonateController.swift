//
//  DonateController.swift
//  PooPee_ios
//
//  Created by ho1 on 9/9/24.
//  Copyright © 2024 ho1. All rights reserved.
//

import UIKit
import StoreKit

class DonateController: BaseController {
    @IBOutlet var root_view: UIView!
    
    @IBOutlet var tv_toolbar_title: UIButton!
    
    @IBOutlet var layout_title_line: UIView!
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var tv_title_sub: UILabel!
    
    @IBOutlet var btn_price_01: UIButton!
    @IBOutlet var btn_price_02: UIButton!
    @IBOutlet var btn_price_03: UIButton!
    
    private var iapManager = IAPManager.shared
    private var productList: [SKProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        
        tv_toolbar_title.setTitle("nav_text_09".localized, for: .normal)
        
        tv_title.text = "menu_donate_01".localized
        tv_title_sub.text = "menu_donate_02".localized
        
        btn_price_01.layer.cornerRadius = 12
        btn_price_02.layer.cornerRadius = 12
        btn_price_03.layer.cornerRadius = 12
        
        _init()
        setListener()
    }
    
    func _init() {
        setTitle()
        loadProducts()
    }
    
    func setListener() {
        btn_price_01.setOnClickListener {
            self.makePurchase(product: self.productList[0])
        }
        btn_price_02.setOnClickListener {
            self.makePurchase(product: self.productList[1])
        }
        btn_price_03.setOnClickListener {
            self.makePurchase(product: self.productList[2])
        }
    }
    
    private func setTitle() {
        if let width = tv_title.widthOfSubstring(substring: "PooPee"),
           let xPosition = tv_title.xPositionOfSubstring(substring: "PooPee") {
            layout_title_line.frame = CGRect(x: xPosition, y: tv_title.layer.position.y, width: width, height: 10)
        }
    }
    
    private func loadProducts() {
        iapManager.onProductsFetched = { [weak self] products in
            self?.productList = products
            self?.setProductList()
        }
        iapManager.requestProducts()
    }
    
    private func setProductList() {
        if (productList.count > 0) {
            btn_price_01.setTitle(productList[0].localizedPrice, for: .normal)
            btn_price_01.isHidden = false
        }
        if (productList.count > 1) {
            btn_price_02.setTitle(productList[1].localizedPrice, for: .normal)
            btn_price_02.isHidden = false
        }
        if (productList.count > 2) {
            btn_price_03.setTitle(productList[2].localizedPrice, for: .normal)
            btn_price_03.isHidden = false
        }
    }
    private func makePurchase(product: SKProduct) {
        iapManager.onPurchaseCompleted = { success, message in
            if (success) {
                let dialog = BasicDialog(
                    onLeftButton: {
                        
                    },
                    onRightButton: {
                        self.finish()
                    })
                dialog.setTextContent("menu_donate_03".localized)
                dialog.setBtnRight("confirm".localized)
                dialog.show(view: ObserverManager.root.view)
            }
        }
        
        iapManager.purchase(product)
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}
