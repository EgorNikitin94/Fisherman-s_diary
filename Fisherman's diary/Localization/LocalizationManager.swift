//
//  LocalizationManager.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 05.02.2021.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
