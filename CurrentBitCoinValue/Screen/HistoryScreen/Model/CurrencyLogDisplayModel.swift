//
//  CurrencyLogDisplayModel.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation

struct CurrencyLogDisplayModel {
    let uuid: String = UUID().uuidString
    let date: String
    let usdRate: String
    let gbpRate: String
    let eurRate: String
}
