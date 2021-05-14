//
//  User.swift
//  Pass
//
//  Created by 강민석 on 2021/04/05.
//

import Foundation

struct User: ModelType {
    enum Event {}
    
    var id: String
    var name: String
    var phone: String
    var email: String
    var avatar: URL
    
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phone
        case email
        case createdAt = "created_at"
        case avatar
    }
}
