//
//  FloatingPoint+Extension.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation

public extension FloatingPoint {
    func fixedFraction(digits: Int, clean: Bool = false) -> String {
        return fixedFraction(minDigits: clean ? 0 : digits, maxDigits: digits)
    }
    
    func fixedFraction(minDigits: Int, maxDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maxDigits
        formatter.minimumFractionDigits = minDigits
        return formatter.string(for : self)!
    }
}
