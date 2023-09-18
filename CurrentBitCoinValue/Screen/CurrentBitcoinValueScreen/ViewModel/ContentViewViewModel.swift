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
    init(getLatestBitcoinValueUseCase: GetLatestBitcoinValueUseCaseProtocol?) {
        self.getLatestBitcoinValueUseCase = getLatestBitcoinValueUseCase
        
        setupConverter()
        setupGetApi()
    }
    
    @Published var selectedCurrency: CurrencyBitCoinValueModel?
    @Published var currencyValue: String = ""
    @Published var currencies: [CurrencyBitCoinValueModel] = []
    @Published var bitcoinValue: String = ""
    
    private var getLatestBitcoinValueUseCase: GetLatestBitcoinValueUseCaseProtocol?
    private var cancellables: [AnyCancellable] = []
    
    private func setupConverter() {
        $currencyValue.sink { [weak self] currencyValueInString in
            let filterCommaString = currencyValueInString.filter({$0.isNumber || $0 == "."})
            self?.updateConversionValue(currencyValueInString: filterCommaString)
        }
        .store(in: &cancellables)
    }
    
    private func calculateConversionValue(currencyValue: Double) -> Double? {
        guard let selectedCurrency = selectedCurrency,
              selectedCurrency.currencyValueForOneBitcoin != 0 else { return nil }
        let bitcoinValue = currencyValue / selectedCurrency.currencyValueForOneBitcoin
        return bitcoinValue
    }
    
    private func setupGetApi() {
        getLatestBitcoinValueApi()
        
        let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
        timer.sink { [weak self] _ in
            self?.getLatestBitcoinValueApi()
        }
        .store(in: &cancellables)
    }
    
    private func getLatestBitcoinValueApi() {
        Task.init {
            let result = await self.getLatestBitcoinValueUseCase?.execute()
            switch result {
            case .success(let response):
                self.handleLatestBitcoinValueApi(response: response)
            case .failure(let error):
                debugPrint(error)
            case .none:
                ()
            }
        }
    }
    
    private func handleLatestBitcoinValueApi(response: LatestBitcoinValueResponseModel) {
        guard let usdRate = Double(response.bpi.USD.rate.filter({$0.isNumber || $0 == "."})) else { return }
        guard let gbpRate = Double(response.bpi.GBP.rate.filter({$0.isNumber || $0 == "."})) else { return }
        guard let eurRate = Double(response.bpi.EUR.rate.filter({$0.isNumber || $0 == "."})) else { return }
        
        let usd = CurrencyBitCoinValueModel(currencyName: response.bpi.USD.code, currencyValueForOneBitcoin: usdRate)
        let gbp = CurrencyBitCoinValueModel(currencyName: response.bpi.GBP.code, currencyValueForOneBitcoin: gbpRate)
        let eur = CurrencyBitCoinValueModel(currencyName: response.bpi.EUR.code, currencyValueForOneBitcoin: eurRate)
        let currencies = [usd, gbp, eur]
        setCurrencyData(currencies: currencies)
        
        AppCurrencyLog.shared.logData(usdRate: usdRate, gbpRate: gbpRate, eurRate: eurRate)
    }
    
    private func setCurrencyData(currencies: [CurrencyBitCoinValueModel]) {
        DispatchQueue.main.async {
            self.currencies = currencies
            if self.selectedCurrency == nil {
                self.selectedCurrency = currencies.first
            }
            self.updateConversionValue(currencyValueInString: self.currencyValue)
        }
    }
    
    private func updateConversionValue(currencyValueInString: String) {
        if let currencyValue = Double(currencyValueInString),
           let bitcoinValue = calculateConversionValue(currencyValue: currencyValue) {
            let bitcoinString = String(format: "%.8f", bitcoinValue)
            self.bitcoinValue = bitcoinString
        } else {
            self.bitcoinValue = ""
        }
    }
}



