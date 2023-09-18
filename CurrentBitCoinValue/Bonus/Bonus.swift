//
//  Bonus.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation

class Bonus {
    func fibonacci(number: Int) -> Int {
        if number == 0 || number == 1 {
            return number
        } else {
            return fibonacci(number: number - 1) + fibonacci(number: number - 2)
        }
    }
    
    func filterArray(array1: inout [Int], array2: inout [Int]) {
        var newArray: [Int] = []
        array2.forEach{ n2 in
            array1.forEach { n1 in
                if n1 == n2 {
                    newArray.append(n1)
                }
            }
        }
        
        array1 = newArray
    }
}
