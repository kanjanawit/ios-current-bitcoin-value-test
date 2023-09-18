//
//  ContentView.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 11/9/2566 BE.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewViewModel
    var body: some View {
        VStack {
            Spacer()
            CurrentBitcoinValueView()
            
            Spacer()
            
            CurrencyToBitcoinConverterView()
            
            Spacer()
        }
        .padding()
        .environmentObject(viewModel)
    }
}

struct CurrentBitcoinValueView: View {
    @EnvironmentObject var viewModel: ContentViewViewModel
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Current BitCoin Value")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                
                HStack(spacing: 3) {
                    ForEach(viewModel.currencies, id: \.hashValue) { currency in
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
    @EnvironmentObject var viewModel: ContentViewViewModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Value Calculation")
                    .font(.largeTitle)
                HStack {
                    Picker("Select Currency", selection: $viewModel.selectedCurrency) {
                        ForEach(viewModel.currencies, id: \.self) {
                            Text($0.currencyName)
                        }
                    }
                    .pickerStyle(.automatic)
                    
                    TextField("", text: $viewModel.currencyValue)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("Bitcoin Value: ")
                    Text(viewModel.bitcoinValue)
                    
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
    static var previews: some View {
        ContentView(
            viewModel: ContentViewViewModel(getLatestBitcoinValueUseCase: nil)
        )
    }
}


