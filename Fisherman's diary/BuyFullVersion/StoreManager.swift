//
//  StoreManager.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 05.02.2021.
//

import UIKit
import StoreKit

final class StoreManager: NSObject {
    static var isFullVersion: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isFull")
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.bool(forKey: "isFull")
        }
    }
    
    func buyFullVersion() {
        
        if let fullVersionProduct = fullVersionProduct {
            let payment = SKPayment(product: fullVersionProduct)
            SKPaymentQueue.default().add(payment)
            SKPaymentQueue.default().add(self)
        } else {
            if !SKPaymentQueue.canMakePayments() {
                print("Не возможно совершить покупку")
                 return
            }
            
            let request = SKProductsRequest(productIdentifiers: ["LocationNotesIDFullVersion"])
            request.delegate = self
            request.start()
        }
    }
    
    func restoreFullVersion() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.invalidProductIdentifiers.count != 0 {
            print("Есть неактуальные продукты \(response.invalidProductIdentifiers)")
        }
        
        if response.products.count > 0 {
            fullVersionProduct = response.products[0]
            self.buyFullVersion()
        }
    }
}

extension StoreManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transection in transactions {
            switch transection.transactionState {
            case .deferred:
                print("deferred")
            case .failed:
                print("failed")
                print("error: \(String(describing: transection.error?.localizedDescription))")
                queue.finishTransaction(transection)
                queue.remove(self)
            case .purchased:
                print("purchased")
                if transection.payment.productIdentifier == "LocationNotesIDFullVersion" {
                    StoreManager.isFullVersion = true
                }
                queue.finishTransaction(transection)
                queue.remove(self)
            case .purchasing:
                print("purchasing")
            case .restored:
                print("restored")
                if transection.payment.productIdentifier == "LocationNotesIDFullVersion" {
                    StoreManager.isFullVersion = true
                }
                queue.finishTransaction(transection)
                queue.remove(self)
            @unknown default:
                fatalError()
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
    }
    
    
}
