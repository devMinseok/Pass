//
//  AccountHistory.swift
//  Pass
//
//  Created by 강민석 on 2021/05/17.
//

import Foundation

struct AccountHistory: ModelType {
    enum Event { }
    
    var idx: Int
    
    /// 거래인 명
    var targetName: String
    
    // 거래 금액
    var amount: Int
    
    // 거래 날짜 (시간)
    var date: Date
    
    // 거래 후 잔액
    var balance: Int
    
    // 거래 플랫폼명
    var platformName: String
    
    enum CodingKeys: String, CodingKey {
        case idx
        case targetName = "target_name"
        case amount
        case date
        case balance
        case platformName = "platform_name"
    }
}
