//
//  User.swift
//  Pass
//
//  Created by 강민석 on 2021/04/05.
//

import Foundation

struct User: ModelType {
    enum Event {}
    
    var id: Int
    var username: String
    var birthDate: Date
    var phone: String
    var email: String
    
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case birthDate = "birth_date"
        case phone
        case email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
