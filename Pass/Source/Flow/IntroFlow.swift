//
//  IntroFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/04/27.
//

import RxFlow

final class IntroFlow: Flow {
    
    // MARK: - Properties
    private let services: AppServices
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController = UINavigationController().then {
        $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
        $0.navigationBar.shadowImage = UIImage()
        $0.navigationBar.isTranslucent = true
    }
    
    // MARK: - Init
    init(_ services: AppServices) {
        self.services = services
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
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
            
        // 메인화면
        case .mainTabBarIsRequired:
            return .end(forwardToParentFlowWithStep: PassStep.mainTabBarIsRequired)
        
        case .dismiss:
            self.rootViewController.dismiss(animated: true, completion: nil)
            return .none
            
        default:
            return .none
        }
    }
}

extension IntroFlow {
    
    /// Initial Navigate
    private func navigateToIntro() -> FlowContributors {
        let reactor = IntroViewReactor()
        let viewController = IntroViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToLogin() -> FlowContributors {
        let reactor = LoginViewReactor(authService: services.authService, userService: services.userService)
        let viewController = LoginViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToRegister() -> FlowContributors {
        let reactor = RegisterViewReactor(authService: services.authService, userService: services.userService)
        let viewController = RegisterViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPassword() -> FlowContributors {
        let reactor = PasswordViewReactor()
        let viewController = PasswordViewController(reactor: reactor)
        
        self.rootViewController.present(viewController, animated: true, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
