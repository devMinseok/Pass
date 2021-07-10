//
//  SettingsFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/04/27.
//

import RxFlow
import SafariServices
import Carte

final class SettingsFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController = UINavigationController().then {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = R.color.signatureColor()
        navigationBarAppearance.shadowColor = nil
        $0.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    private let services: AppServices
    
    init(_ services: AppServices) {
        self.services = services
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        case .settingsIsRequired:
            return self.navigateToSettings()
            
        case .profileIsRequried:
            return self.navigateToProfile()
            
        case .versionIsRequired:
            return self.navigateToVersion()
            
        case .githubIsRequired:
            return self.navigateToGithub()
            
        case .introIsRequired:
            return .end(forwardToParentFlowWithStep: PassStep.introIsRequired)
            
        default:
            return .none
        }
    }
}

extension SettingsFlow {
    private func navigateToSettings() -> FlowContributors {
        let reactor = SettingsViewReactor(authService: services.authService)
        let viewController = SettingsViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToVersion() -> FlowContributors {
//        let reactor = VersionViewReactor()
//        let viewController = VersionViewController(reactor: reactor)
        
        let viewController = CarteViewController()
        
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
    
    private func navigateToGithub() -> FlowContributors {
        guard let url = URL(string: "https://github.com/devMinseok/Pass") else { return .none }
        let viewController = SFSafariViewController(url: url)
        
        self.rootViewController.present(viewController, animated: true)
        return .none
    }
    
    private func navigateToProfile() -> FlowContributors {
        let reactor = ProfileViewReactor(userService: services.userService)
        let viewController = ProfileViewController(reactor: reactor)
        
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
}
