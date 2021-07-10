//
//  TabBarFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/04/27.
//

import UIKit
import RxFlow

final class TabBarFlow: Flow {
    
    private var rootViewController: UITabBarController
    private let services: AppServices
    
    var root: Presentable {
        return rootViewController
    }
    
    init(_ services: AppServices) {
        self.rootViewController = TabBarViewController()
        self.services = services
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        case .mainTabBarIsRequired:
            return navigateToTabBar()
            
        case .introIsRequired:
            return .end(forwardToParentFlowWithStep: PassStep.introIsRequired)
            
        default:
            return .none
        }
    }
}

extension TabBarFlow {
    private func navigateToTabBar() -> FlowContributors {
        let homeFlow = HomeFlow(self.services)
        let settingsFlow = SettingsFlow(self.services)
        
        Flows.use(homeFlow, settingsFlow, when: .created) { [unowned self] (root1, root2: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "홈", image: R.image.home(), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            
            let tabBarItem2 = UITabBarItem(title: "설정", image: R.image.bar(), selectedImage: nil)
            root2.tabBarItem = tabBarItem2
            
            self.rootViewController.setViewControllers([root1, root2], animated: false)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow,
                        withNextStepper: OneStepper(withSingleStep: PassStep.homeIsRequired)),
            
            .contribute(withNextPresentable: settingsFlow,
                        withNextStepper: OneStepper(withSingleStep: PassStep.settingsIsRequired))
        ])
    }
}
