//
//  SettingsFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/04/27.
//

import RxFlow

final class SettingsFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController: UINavigationController
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        case .settingsIsRequired:
            return self.navigateToSettings()
        default:
            return .none
        }
    }
}

extension SettingsFlow {
    private func navigateToSettings() -> FlowContributors {
        return .none
    }
}
