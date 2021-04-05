//
//  PassAPI.swift
//  Pass
//
//  Created by 강민석 on 2021/04/05.
//

import Moya
import MoyaSugar

enum PassAPI {
    case signup(username: String, password: String, birthDate: Date, phone: String, email: String)
    case login(username: String, password: String)
    case getme
}

extension PassAPI: SugarTargetType {
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8080")!
    }
    
    var route: Route {
        switch self {
        case .signup:
            return .post("/user/signup")
        case .login:
            return .post("/user/login")
        case .getme:
            return .get("/user/me")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .signup(username, password, birthDate, phone, email):
            return [
                "username": username,
                "password": password,
                "birth_date": birthDate,
                "phone": phone,
                "email": email
            ]
        case let .login(username, password):
            return [
                "username": username,
                "password": password
            ]
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
