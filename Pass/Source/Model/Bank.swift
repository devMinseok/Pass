//
//  Bank.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import Foundation

struct Bank: ModelType {
    enum Event {}
    
    var idx: Int
    
    /// 은행명
    var bankName: String
    
    /// 은행 로고
    var logoURL: URL
    
    enum CodingKeys: String, CodingKey {
        case idx
        case bankName = "bank_name"
        case logoURL = "logo_url"
    }
}
