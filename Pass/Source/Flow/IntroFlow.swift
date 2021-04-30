//
//  IntroFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/04/27.
//

import RxFlow

final class IntroFlow: Flow {
    
    // MARK: - Properties
    private let authService: AuthServiceType
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        // Navigation Bar를 transparent하게
        viewController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        viewController.navigationBar.shadowImage = UIImage()
        viewController.navigationBar.isTranslucent = true
        return viewController
    }()
    
    // MARK: - Init
    init() {
        self.authService = DIContainer.shared.container.resolve(AuthServiceType.self)!
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    // MARK: - Navigation Switch
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        // 인트로 화면
        case .introIsRequired:
            return navigateToIntro()
            
        // 로그인
        case .loginIsRequired:
            return navigateToLogin()
            
        // 회원가입
        case .registerIsRequired:
            return navigateToRegister()
            
        // 비밀번호
        case .passwordIsRequired:
            return navigateToPassword()
            
        default:
            return .none
        }
    }
}

extension IntroFlow {
    // MARK: - Navigate to SocialLogin
    private func navigateToIntro() -> FlowContributors {
        let viewController = IntroViewController(reactor: IntroViewReactor())
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    
    private func navigateToLogin() -> FlowContributors {
        let viewController = LoginViewController(reactor: LoginViewReactor())
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    
    private func navigateToRegister() -> FlowContributors {
        let viewController = RegisterViewController(reactor: RegisterViewReactor())
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    
    private func navigateToPassword() -> FlowContributors {
        let viewController = PasswordViewController(reactor: PasswordViewReactor())
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    
}
