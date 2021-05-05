//
//  BaseAPI.swift
//  Pass
//
//  Created by 강민석 on 2021/04/26.
//

import Moya

protocol BaseAPI: TargetType {}

extension BaseAPI {
    var baseURL: URL { URL(string: "https://4978f607-03b5-4521-987a-2b93bc2af13a.mock.pstmn.io")! }
    
    var method: Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task { .requestPlain }
    
    var headers: [String: String]? { nil }
}
