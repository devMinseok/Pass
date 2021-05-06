//
//  HomeFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/04/27.
//

import RxFlow

final class HomeFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController: UINavigationController
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        case .homeIsRequired:
            return self.navigateToHome()
        default:
            return .none
        }
    }
}

extension HomeFlow {
    private func navigateToHome() -> FlowContributors {
        return .none
    }
}
