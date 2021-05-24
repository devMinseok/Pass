//
//  TransferFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import RxFlow

final class TransferFlow: Flow {
    
    // MARK: - Properties
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
        case .transferDestinationIsRequired:
            return navigateToSelectTransferDestination()
            
        case .transferAmountIsRequired:
            return navigateToTransferAmount()
            
        default:
            return .none
        }
    }
}

extension TransferFlow {
    // Initial Navigate
    private func navigateToSelectTransferDestination() -> FlowContributors {
        let reactor = TransferDestinationViewReactor()
        let viewController = TransferDestinationViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTransferAmount() -> FlowContributors {
        
        return .none
    }
}
