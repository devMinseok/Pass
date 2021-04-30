//
//  Token.swift
//  Pass
//
//  Created by 강민석 on 2021/04/13.
//

import Foundation

struct Token: ModelType {
    enum Event {}
    
    var accessToken: String
    var tokenType: String
    var expiresAt: Date
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresAt = "expires_at"
    }
}
