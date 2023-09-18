//
//  CurrencyHistoryViewModel.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation
import SwiftUI

class CurrencyHistoryViewModel: ObservableObject {
    @Published var displayLogs: [CurrencyLogDisplayModel] = []
    
    init() {
        getLogFromPersitence()
        setupNotificationListen()
    }
    
    @objc private func getLogFromPersitence() {
        let displayLogs = AppCurrencyLog.shared.getLogs().reversed().map({ log in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let dateString = dateFormatter.string(from: log.date)
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumFractionDigits = 4
            numberFormatter.maximumFractionDigits = 4
            
            let usdRate = numberFormatter.string(from: NSNumber(value:log.usdRate)) ?? ""
            let gbpRate = numberFormatter.string(from: NSNumber(value:log.gbpRate)) ?? ""
            let eurRate = numberFormatter.string(from: NSNumber(value:log.eurRate)) ?? ""
            return CurrencyLogDisplayModel(date: dateString, usdRate: usdRate, gbpRate: gbpRate, eurRate: eurRate)
        })
        
        set(displayLogs: displayLogs)
    }
    
    private func set(displayLogs: [CurrencyLogDisplayModel]) {
        DispatchQueue.main.async {
            self.displayLogs = displayLogs
        }
    }
    
    private func setupNotificationListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(getLogFromPersitence), name: .didUpdateCurrencyLog, object: nil)
    }
}
