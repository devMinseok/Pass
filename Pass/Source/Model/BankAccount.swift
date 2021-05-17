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
    
    /// 계좌 소유자
    var ownerIdx: Int
    
    /// 은행
    var bank: Bank
    
    /// 잔액
    var balance: Int
    
    /// 계좌번호
    var accountNumber: String
    
    /// 계좌 별칭
    var accountNickname: String
    
    enum CodingKeys: String, CodingKey {
        case idx
        case ownerIdx = "owner_idx"
        case bank
        case balance
        case accountNumber = "account_number"
        case accountNickname = "account_nickname"
    }
}
