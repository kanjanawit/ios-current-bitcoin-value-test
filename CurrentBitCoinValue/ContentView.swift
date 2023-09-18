//
//  ContentView.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 11/9/2566 BE.
//

import SwiftUI

struct ContentView: View {
    init(selectedCurrency: CurrencyBitCoinValueModel, currencies: [CurrencyBitCoinValueModel]) {
        self.selectedCurrency = selectedCurrency
        self.currencies = currencies
    }
    
    @State private var selectedCurrency: CurrencyBitCoinValueModel
    @State private var currencyValue: String = "0.00"
    @State private var currencies: [CurrencyBitCoinValueModel]
    
    var body: some View {
        VStack {
            Spacer()
            CurrentBitcoinValueView(currencies: currencies)
            
            Spacer()
            CurrencyToBitcoinConverterView(selectedCurrency: selectedCurrency, currencyValue: currencyValue, currencies: currencies)
            
            Spacer()
        }
        .padding()
    }
}

struct CurrentBitcoinValueView: View {
    init(currencies: [CurrencyBitCoinValueModel]) {
        self.currencies = currencies
    }
    
    @State private var currencies: [CurrencyBitCoinValueModel]
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Current BitCoin Value")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                
                HStack(spacing: 3) {
                    ForEach(currencies, id: \.hashValue) { currency in
                        OneBitCoinCurrencyValueView(currencyName: currency.currencyName, currencyValueForOneCoin: currency.currencyValueString)
                    }
                }
                
                Button(action: {
                    // Navigate to Currency History
                }, label: {
                    Text("Value History")
                        .font(.title3)
                        .foregroundColor(.blue)
                })
                .padding(.top, 10)
            }
            
            Spacer()
        }
        .overlay {
            Rectangle()
                .stroke(lineWidth: 1)
        }
    }
}

struct OneBitCoinCurrencyValueView: View {
    let currencyName: String
    let currencyValueForOneCoin: String
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(currencyName)
                    .font(.title)
                Text(currencyValueForOneCoin)
                    .font(.title3)
            }
            Spacer()
        }
        .overlay {
            Rectangle()
                .stroke(lineWidth: 1)
        }
    }
}

struct CurrencyToBitcoinConverterView: View {
    init(selectedCurrency: CurrencyBitCoinValueModel, currencyValue: String, currencies: [CurrencyBitCoinValueModel]) {
        self.selectedCurrency = selectedCurrency
        self.currencyValue = currencyValue
        self.currencies = currencies
    }
    
    @State private var selectedCurrency: CurrencyBitCoinValueModel
    @State private var currencyValue: String
    @State private var currencies: [CurrencyBitCoinValueModel]
    @State private var bitcoinValue: String = ""

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Value Calculation")
                    .font(.largeTitle)
                HStack {
                    Picker("Select Currency", selection: $selectedCurrency) {
                        ForEach(currencies, id: \.self) {
                            Text($0.currencyName)
                        }
                    }
                    .pickerStyle(.automatic)
                    
                    TextField("", text: $currencyValue)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("Bitcoin Value: ")
                    Text(bitcoinValue)
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
        .overlay {
            Rectangle()
                .stroke(lineWidth: 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let currencies = [
        CurrencyBitCoinValueModel(currencyName: "USD", currencyValueForOneBitcoin: 35000),
        CurrencyBitCoinValueModel(currencyName: "GBP", currencyValueForOneBitcoin: 45000),
        CurrencyBitCoinValueModel(currencyName: "EUR", currencyValueForOneBitcoin: 25000)
    ]
    static var previews: some View {
        ContentView(selectedCurrency: currencies.first!, currencies: currencies)
    }
}

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
