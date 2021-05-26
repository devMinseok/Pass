//
//  Int.swift
//  Pass
//
//  Created by 강민석 on 2021/05/12.
//

import Foundation

extension Int {
    func decimalWon() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: self))! + " 원"
        
        return result
    }
}
