//
//  ContentViewViewModel.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation
import SwiftUI

class ContentViewViewModel: ObservableObject {
    internal init(
        selectedCurrency: CurrencyBitCoinValueModel,
        currencyValue: String,
        currencies: [CurrencyBitCoinValueModel],
        bitcoinValue: String
    ) {
        self.selectedCurrency = selectedCurrency
        self.currencyValue = currencyValue
        self.currencies = currencies
        self.bitcoinValue = bitcoinValue
        self.currencyValue = currencyValue
    }
    
    @Published var selectedCurrency: CurrencyBitCoinValueModel
    @Published var currencyValue: String
    @Published var currencies: [CurrencyBitCoinValueModel]
    @Published var bitcoinValue: String
}
