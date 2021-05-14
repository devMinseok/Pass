//
//  MyConsumeFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/04/27.
//

import RxFlow

final class MyConsumeFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController: UINavigationController
    
    init(_ services: AppServices) {
        self.rootViewController = UINavigationController()
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        case .myConsumeIsRequired:
            return self.navigateToMyConsume()
        default:
            return .none
        }
    }
}

extension MyConsumeFlow {
    private func navigateToMyConsume() -> FlowContributors {
        return .none
    }
}
