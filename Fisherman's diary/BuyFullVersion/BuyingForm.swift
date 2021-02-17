//
//  BuyngForm.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 05.02.2021.
//

import UIKit

final class BuyingForm {
    
    var isNeedToShow: Bool {
        if StoreManager.isFullVersion {
            return false
        } else {
            guard  Storage.notes.count <= 3 else {return true}
            return false
        }
    }
    
    private var storeManager = StoreManager()
    
    func showForm(inController: UIViewController) {
        if let fullVersionProduct = fullVersionProduct {
            let alertController = UIAlertController(title: fullVersionProduct.localizedTitle, message: fullVersionProduct.localizedDescription, preferredStyle: .alert)
            
            guard let currencySymbol = fullVersionProduct.priceLocale.currencySymbol else { return }
            
            let actionBuy = UIAlertAction(title: "Buy for \(fullVersionProduct.price) \(currencySymbol)", style: .default, handler: {(alert) in
                self.storeManager.buyFullVersion()
            })
            
            let actionRestore = UIAlertAction(title: "Restore", style: .default, handler: {(alert) in
                self.storeManager.restoreFullVersion()
            })
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertController.addAction(actionBuy)
            alertController.addAction(actionRestore)
            alertController.addAction(actionCancel)
            
            inController.present(alertController, animated: true, completion: nil)
        }
    }
}
