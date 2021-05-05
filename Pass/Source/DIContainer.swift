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
    }
    
    func register() {
        
        // MARK: - Service
        container.register(AuthServiceType.self) { _ in AuthService() }
        
        let network = Network<PassAPI>(
            plugins: [
                RequestLoggingPlugin(),
                AuthPlugin(authService: self.container.resolve(AuthServiceType.self)!)
            ]
        )
        
        container.register(UserServiceType.self) { _ in UserService(network: network) }
        
        // MARK: - Register Controller
        self.container.register(SplashViewController.self) { resolver in
            let reactor = SplashViewReactor()
            return SplashViewController(reactor: reactor)
        }
        
        self.container.register(IntroViewController.self) { resolver in
            let reactor = IntroViewReactor()
            return IntroViewController(reactor: reactor)
        }
    }
}