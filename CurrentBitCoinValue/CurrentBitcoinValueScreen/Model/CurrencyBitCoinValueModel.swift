//
//  CurrencyBitCoinValueModel.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation
class CurrencyBitCoinValueModel: Equatable, Hashable {
    internal init(currencyName: String, currencyValueForOneBitcoin: Double) {
        self.currencyName = currencyName
        self.currencyValueForOneBitcoin = currencyValueForOneBitcoin
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(currencyName)
        hasher.combine(currencyValueForOneBitcoin)
    }
    
    static func == (lhs: CurrencyBitCoinValueModel, rhs: CurrencyBitCoinValueModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
    var currencyName: String
    var currencyValueForOneBitcoin: Double
    
    var currencyValueString: String {
        return String(format: "%.4f", currencyValueForOneBitcoin)
    }
}
