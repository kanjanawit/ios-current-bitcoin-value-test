//
//  ContentViewViewModel.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation
import SwiftUI
import Combine

class ContentViewViewModel: ObservableObject {
    internal init(
        selectedCurrency: CurrencyBitCoinValueModel?,
        currencyValue: String,
        currencies: [CurrencyBitCoinValueModel],
        bitcoinValue: String
    ) {
        self.selectedCurrency = selectedCurrency
        self.currencyValue = currencyValue
        self.currencies = currencies
        self.bitcoinValue = bitcoinValue
        self.currencyValue = currencyValue
        
        setupConverter()
    }
    
    @Published var selectedCurrency: CurrencyBitCoinValueModel?
    @Published var currencyValue: String
    @Published var currencies: [CurrencyBitCoinValueModel]
    @Published var bitcoinValue: String
    
    private var cancellables: [AnyCancellable] = []
    
    private func setupConverter() {
        $currencyValue.sink { [weak self] currencyValueInString in
            if let currencyValue = Double(currencyValueInString),
               let selectedCurrency = self?.selectedCurrency,
               selectedCurrency.currencyValueForOneBitcoin != 0 {
                let bitcoinValue = currencyValue / selectedCurrency.currencyValueForOneBitcoin
                let bitcoinString = String(format: "%.8f", bitcoinValue)
                self?.bitcoinValue = bitcoinString
            } else {
                self?.bitcoinValue = ""
            }
        }
        .store(in: &cancellables)
    }
}
