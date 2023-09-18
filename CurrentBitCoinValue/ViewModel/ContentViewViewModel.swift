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
        setupGetApi()
    }
    
    @Published var selectedCurrency: CurrencyBitCoinValueModel?
    @Published var currencyValue: String
    @Published var currencies: [CurrencyBitCoinValueModel]
    @Published var bitcoinValue: String
    
    private var cancellables: [AnyCancellable] = []
    
    private func setupConverter() {
        $currencyValue.sink { [weak self] currencyValueInString in
            self?.updateConversionValue(currencyValueInString: currencyValueInString)
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
        
        let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        timer.sink { [weak self] _ in
            self?.getLatestBitcoinValueApi()
        }
        .store(in: &cancellables)
    }
    
    private func getLatestBitcoinValueApi() {
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            [weak self] data, response, error in
            
            if let data = data {
                if let string = String(data: data, encoding: .utf8){
                    print(string)
                    
                }
                let decoder = JSONDecoder()
                
                do {
                    let responseObject = try decoder.decode(LatestBitcoinValueResponseModel.self, from: data)
                    self?.handleLatestBitcoinValueApi(response: responseObject)
                } catch {
                    print(error)
                }
            }
        }
        
        task.resume()
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



