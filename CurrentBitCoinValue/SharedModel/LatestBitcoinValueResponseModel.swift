//
//  LatestBitcoinValueResponseModel.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation

struct LatestBitcoinValueResponseModel: Codable {
    let time: TimeResponseModel
    let bpi: BpiValueResponseModel
    
    struct TimeResponseModel: Codable {
        let updated: String
        let updatedISO: String
        let updateduk: String
    }

    struct BpiValueResponseModel: Codable {
        let USD: CurrencyBitcoinValueResponseModel
        let GBP: CurrencyBitcoinValueResponseModel
        let EUR: CurrencyBitcoinValueResponseModel
    }

    struct CurrencyBitcoinValueResponseModel: Codable {
        let code: String
        let rate: String
    }
}
