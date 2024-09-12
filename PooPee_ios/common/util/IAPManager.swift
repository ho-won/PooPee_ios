//
//  IAPManager.swift
//  PooPee_ios
//
//  Created by ho1 on 9/9/24.
//  Copyright © 2024 ho1. All rights reserved.
//

import UIKit
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    var products: [SKProduct] = []
    private let productIDs = Set(["poopee_donate_01", "poopee_donate_02", "poopee_donate_03"])
    var onProductsFetched: (([SKProduct]) -> Void)?
    var onPurchaseCompleted: ((Bool, String?) -> Void)?
    
    func requestProducts() {
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            //self.products = response.products
            self.products = response.products.sorted { $0.price.compare($1.price) == .orderedAscending }
            self.onProductsFetched?(self.products)
        }
    }
    
    func purchase(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                handlePurchased(transaction)
            case .failed:
                handleFailed(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func handlePurchased(_ transaction: SKPaymentTransaction) {
        // 여기에서 구매한 상품에 따른 보상을 제공합니다.
        print("상품 구매 완료: \(transaction.payment.productIdentifier)")
        
        SKPaymentQueue.default().finishTransaction(transaction)
        DispatchQueue.main.async {
            self.onPurchaseCompleted?(true, transaction.payment.productIdentifier)
        }
    }
    
    private func handleFailed(_ transaction: SKPaymentTransaction) {
        print("구매 실패: \(String(describing: transaction.error))")
        SKPaymentQueue.default().finishTransaction(transaction)
        DispatchQueue.main.async {
            self.onPurchaseCompleted?(false, transaction.error?.localizedDescription)
        }
    }
}

extension SKProduct {
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
}
