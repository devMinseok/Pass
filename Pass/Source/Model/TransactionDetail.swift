//
//  TransactionDetail.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import Foundation

struct TransactionDetail: ModelType {
    enum Event { }
    
    var idx: Int
    var withdrawalBankIdx: Int
    var depositBankIdx: Int
    var amount: Int
    var memo: String
    var transferDate: Date
    var isHide: Bool
    var isTotalSpendingIncluded: Bool
    
    enum CodingKeys: String, CodingKey {
        case idx
        case withdrawalBankIdx = "withdrawal_bank_idx"
        case depositBankIdx = "deposit_bank_idx"
        case amount
        case memo
        case transferDate = "transfer_date"
        case isHide = "is_hide"
        case isTotalSpendingIncluded = "is_total_spending_included"
    }
}
