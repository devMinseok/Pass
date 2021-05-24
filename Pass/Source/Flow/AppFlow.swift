//
//  AppFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/04/26.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

final class AppFlow: Flow {
    
    private let window: UIWindow
    private let services: AppServices
    
    var root: Presentable {
        return self.window
    }
    
    init(window: UIWindow, services: AppServices) {
        self.window = window
        self.services = services
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        case .splashIsRequired:
            return navigateToSplash()
            
        case .introIsRequired:
            return navigateToIntro()
            
        case .mainTabBarIsRequired:
            return navigateToTabBar()
            
        default:
            return .none
        }
    }
}

extension AppFlow {
    private func navigateToSplash() -> FlowContributors {
        let viewController = SplashViewController(reactor: SplashViewReactor())
        
        self.window.rootViewController = viewController
        
        UIView.transition(with: self.window,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
        return .none
    }
    
    private func navigateToIntro() -> FlowContributors {
        let introFlow = IntroFlow(services)
        
        Flows.use(introFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root
            
            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
        
        let nextStep = OneStepper(withSingleStep: PassStep.introIsRequired)
        return .one(flowContributor: .contribute(withNextPresentable: introFlow, withNextStepper: nextStep))
    }
    
    private func navigateToTabBar() -> FlowContributors {
        let tabBarFlow = TabBarFlow(services)
        
        Flows.use(tabBarFlow, when: .ready) { [unowned self] root in
            self.window.rootViewController = root
            
            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
        
        let nextStep = OneStepper(withSingleStep: PassStep.mainTabBarIsRequired)
        return .one(flowContributor: .contribute(withNextPresentable: tabBarFlow, withNextStepper: nextStep))
    }
}

/// User 정보 확인후 화면 결정
class AppStepper: Stepper {

    let userService: UserServiceType
    
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return PassStep.splashIsRequired
    }
    
    init(_ userService: UserServiceType) {
        self.userService = userService
    }

    // 사용자 정보 받아오기 성공시 실행되는 콜백 메서드
    func readyToEmitSteps() {
        self.userService.fetchUser()
            .asObservable()
            .map { true }
            .catchErrorJustReturn(false)
            .map { $0 ? PassStep.mainTabBarIsRequired : PassStep.introIsRequired } // 정상
//            .map { $0 ? PassStep.introIsRequired : PassStep.mainTabBarIsRequired } // 메인 테스트용
            .bind(to: self.steps)
            .disposed(by: disposeBag)
    }
}
