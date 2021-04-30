//
//  AuthAPI.swift
//  Pass
//
//  Created by 강민석 on 2021/04/26.
//

import RxSwift
import Moya

enum AuthAPI {
    case login(_ email: String, _ password: String)
    case register(_ password: String, _ name: String, _ email: String, _ phone: String, _ birth: Date)
}

extension AuthAPI: BaseAPI {
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register:
            return .post
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
        case let .login(email, password):
            return [
                "email": email,
                "password": password
            ]
            
        case let .register(password, name, email, phone, birth):
            return [
                "password": password,
                "name": name,
                "email": email,
                "phone": phone,
                "birth": birth
            ]
        }
    }
}
