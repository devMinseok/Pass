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
    
    var root: Presentable {
        return rootViewController
    }
    
    init() {
        self.rootViewController = TabBarViewController()
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        case .mainTabBarIsRequired:
            return navigateToTabBar()
            
        default:
            return .none
        }
    }
}

extension TabBarFlow {
    private func navigateToTabBar() -> FlowContributors {
        let homeFlow = HomeFlow()
        let myConsumeFlow = MyConsumeFlow()
        let settingsFlow = SettingsFlow()
        
        Flows.use(homeFlow, myConsumeFlow, settingsFlow, when: .created) { [unowned self] (root1, root2, root3: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: nil, image: R.image.home(), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root1.title = "홈"
            
            let tabBarItem2 = UITabBarItem(title: nil, image: R.image.calendar(), selectedImage: nil)
            root2.tabBarItem = tabBarItem2
            root2.title = "내 소비"
            
            let tabBarItem3 = UITabBarItem(title: nil, image: R.image.bar(), selectedImage: nil)
            root3.tabBarItem = tabBarItem3
            root3.title = "설정"
            
            self.rootViewController.setViewControllers([root1, root2, root3], animated: false)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow,
                        withNextStepper: OneStepper(withSingleStep: PassStep.homeIsRequired)),
            
            .contribute(withNextPresentable: myConsumeFlow,
                        withNextStepper: OneStepper(withSingleStep: PassStep.myConsumeIsRequired)),
            
            .contribute(withNextPresentable: settingsFlow,
                        withNextStepper: OneStepper(withSingleStep: PassStep.settingsIsRequired))
        ])
    }
}