//
//  AppCurrencyLog.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation

class AppCurrencyLog {
    static var shared: AppCurrencyLog = AppCurrencyLog()
    
    private var logs: [CurrencyLogModel] = []
    
    func getLogs() -> [CurrencyLogModel] {
        return logs
    }
    
    func logData(usdRate: Double, gbpRate: Double, eurRate: Double) {
        let log = CurrencyLogModel(date: Date(), usdRate: usdRate, gbpRate: gbpRate, eurRate: eurRate)
        add(log: log)
        sendUpdateNotification()
    }
    
    private func add(log: CurrencyLogModel) {
        logs.append(log)
    }
    
    private func sendUpdateNotification() {
        NotificationCenter.default.post(name: .didUpdateCurrencyLog, object: nil)
    }
}
