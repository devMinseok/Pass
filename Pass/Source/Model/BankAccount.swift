//
//  BankAccount.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import Foundation

struct BankAccount: ModelType {
    enum Event {}
    
    var idx: Int
    var ownerIdx: Int
    var bank: Bank
    var balance: Int
    var accountNumber: String
    var accountNickname: String
    var isFrequent: Bool
    var isTotalSpendingIncluded: Bool
    
    enum CodingKeys: String, CodingKey {
        case idx
        case ownerIdx = "owner_idx"
        case bank
        case balance
        case accountNumber = "account_number"
        case accountNickname = "account_nickname"
        case isFrequent = "is_frequent"
        case isTotalSpendingIncluded = "is_total_spending_included"
    }
}


//{
//    "idx": 1, // 계좌 고유번호
//    "owner_idx": 1, // 계좌 소유자 고유번호
//    "bank": {
//        "idx": 1,
//        "bank_name": "",
//        "thumbnail": ""
//    }, // 은행 정보
//    "balance": 123, // 잔여 금액
//    "account_number": "123456789", // 계좌번호
//    "account_nickname": "NH", // 계좌 별칭
//    "is_frequent": true, // 자주 사용하는 계좌인지?
//    "is_total_spending_included": false // 총 소비 금액에 포함 시킬지?
//}
