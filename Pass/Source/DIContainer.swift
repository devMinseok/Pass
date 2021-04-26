//
//  CompositionRoot.swift
//  Pass
//
//  Created by 강민석 on 2021/04/06.
//

import Kingfisher
import RxViewController
import RxOptional
import Swinject
import SnapKit
import Then

class DIContainer {
    
    static let shared = DIContainer()
    
    let container: Container
    
    fileprivate init() {
        self.container = Container()
        
        self.register()
    }
    
    func register() {
        // Service 등록
        self.container.register(AuthService.self) { _ in
            return AuthService()
        }
        
        let network = Network<PassAPI>(
            plugins: [
                RequestLoggingPlugin(),
                AuthPlugin(authService: self.container.resolve(AuthService.self)!)
            ]
        )
        
        self.container.register(UserService.self) { resolver in
            return UserService(network: network)
        }
        
        // ViewController 등록
//        self.container.register(SplashViewController.self) { resolver in
//            let reactor = SplashViewReactor()
//            let controller = SplashViewController(reactor: reactor)
//
//            return controller
//        }
        
//        self.container.register(<#T##serviceType: Service.Type##Service.Type#>, factory: <#T##(Resolver) -> Service#>)
    }
}
