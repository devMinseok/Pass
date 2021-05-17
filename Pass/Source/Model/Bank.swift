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
    var name: String
    var thumbnail: URL
    
    enum CodingKeys: String, CodingKey {
        case idx
        case name = "bank_name"
        case thumbnail
    }
}

//"bank": {
//    "idx": 1,
//    "bank_name": "",
//    "thumbnail": ""
//}
