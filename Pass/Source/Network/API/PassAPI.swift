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
    case getBankList
    
    case transfer(_ depositAccountNumber: String, _ withdrawalAccountNumber: String, _ amount: Int) // 입금계좌번호, 출금계좌번호, 송금금액
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
            
        case .getBankList:
            return "/account/bankList"
        case .transfer:
            return "/account/transfer"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .transfer:
            return .post
            
        case .getMyInfo, .getMyAccounts, .getAccountHistory, .getBankList:
            return .get
            
        case .editMyInfo:
            return .patch
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .editMyInfo(name, phone, email):
            return [
                "name": name,
                "phone": phone,
                "email": email
            ]
            
        case let .transfer(depositAccountNumber, withdrawalAccountNumber, amount):
            return [
                "deposit": depositAccountNumber,
                "withdrawal": withdrawalAccountNumber,
                "amount": amount
            ]
            
        default:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            }
            return .requestPlain
        }
    }
}
