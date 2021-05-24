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
    
    /// 출금처
    var withdrawalName: String
    
    /// 입금처
    var depositName: String
    
    /// 금액
    var amount: Int
    
    /// 메모
    var memo: String
    
    /// 거래 일자
    var date: Date
    
    /// 지출 합계 포함 여부
    var isTotalSpendingIncluded: Bool
    
    enum CodingKeys: String, CodingKey {
        case idx
        case withdrawalName = "withdrawal_name"
        case depositName = "deposit_name"
        case amount
        case memo
        case date
        case isTotalSpendingIncluded = "is_total_spending_included"
    }
}
