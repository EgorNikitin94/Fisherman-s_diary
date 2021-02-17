//
//  PriceManager.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 05.02.2021.
//

import UIKit
import StoreKit

public var fullVersionProduct: SKProduct? 

final class PriceManager: NSObject {
    
    func getPriceForProduct(idProduct: String) {
        if !SKPaymentQueue.canMakePayments() {
            print("Не возможно совершить покупку")
             return
        }
        
        let request = SKProductsRequest(productIdentifiers: [idProduct])
        request.delegate = self
        request.start()
    }
    
}

extension PriceManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.invalidProductIdentifiers.count != 0 {
            print("Есть неактуальные продукты \(response.invalidProductIdentifiers)")
        }
        
        if response.products.count > 0 {
            fullVersionProduct = response.products[0]
        }
    }
}
