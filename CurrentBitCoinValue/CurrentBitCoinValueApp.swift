//
//  CurrentBitCoinValueApp.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 11/9/2566 BE.
//

import SwiftUI

@main
struct CurrentBitCoinValueApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: ContentViewViewModel(
                    selectedCurrency: ContentView_Previews.currencies.first!,
                    currencyValue: "",
                    currencies: ContentView_Previews.currencies,
                    bitcoinValue: "")
            )
        }
    }
}
