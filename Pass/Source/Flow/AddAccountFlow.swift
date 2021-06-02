//
//  AddAccountFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/06/02.
//

import RxFlow

final class AddAccountFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController: BankCheckListViewController
    
    private let services: AppServices
    
    init(
        _ services: AppServices
    ) {
        self.services = services
        
        let reactor = BankListViewReactor(accountService: services.accountService)
        self.rootViewController = BankCheckListViewController(reactor: reactor)
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        case .bankCheckListIsRequired:
            return navigateToBankCheckList()
            
        case let .inputAccountNumberIsRequired(bank):
            return navigateToInputAccountNumber(bank)
            
        case .popViewController:
            self.rootViewController.navigationController?.popToRootViewController(animated: true)
            return .none
        default:
            return .none
        }
    }
}

extension AddAccountFlow {
    private func navigateToBankCheckList() -> FlowContributors {
        guard let nextStepper = rootViewController.reactor else { return .none }
        return .one(flowContributor: .contribute(withNextPresentable: rootViewController, withNextStepper: nextStepper))
    }
    
    private func navigateToInputAccountNumber(_ bank: Bank) -> FlowContributors {
        
        return .none
    }
}
