//
//  PassAPI.swift
//  Pass
//
//  Created by 강민석 on 2021/04/05.
//

import RxSwift
import Moya

enum PassAPI {
    case getMyInfo
    case editMyInfo(_ name: String, _ phone: String, _ email: String)
    case getMyAccounts
    case getAccountHistory(_ idx: Int)
}

extension PassAPI: BaseAPI {
    var path: String {
        switch self {
        case .getMyInfo:
            return "/user/getMyInfo"
        case .editMyInfo:
            return "/user/editMyInfo"
        case .getMyAccounts:
            return "/account/getMyAccounts"
        case let .getAccountHistory(idx):
            return "/account/getAccountHistory/\(idx)"
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case :
//            return .post
            
        case .getMyInfo, .getMyAccounts, .getAccountHistory:
            return .get
            
        case .editMyInfo:
            return .patch
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
//    var task: Task {
//        switch self {
//        case :
//
//        }
//    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .editMyInfo(name, phone, email):
            return [
                "name": name,
                "phone": phone,
                "email": email
            ]
            
        default:
            return nil
        }
    }
}
