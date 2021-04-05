//
//  Network.swift
//  Pass
//
//  Created by 강민석 on 2021/04/05.
//

import Moya
import MoyaSugar
import RxSwift

final class Netwrok<Target: SugarTargetType>: MoyaSugarProvider<Target> {
    
    init(plugins: [PluginType] = []) {
        let session = MoyaProvider<Target>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        
        super.init(session: session, plugins: plugins)
    }
    
    private let provider = MoyaProvider<Target>(plugins: [RequestLoggingPlugin()])
    
    func reqeust(_ target: Target) -> Single<Response> {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
    }
}
