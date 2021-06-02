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
    
    private let rootViewController: TransferDestinationViewController
    
    private let services: AppServices
    private let bankAccount: BankAccount?
    
    init(_ services: AppServices, bankAccount: BankAccount?) {
        self.services = services
        self.bankAccount = bankAccount
        
        let reactor = TransferDestinationViewReactor()
        self.rootViewController = TransferDestinationViewController(reactor: reactor)
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PassStep else { return .none }
        
        switch step {
        case .transferDestinationIsRequired:
            return navigateToTransferDestination()
            
        case .bankListIsRequired:
            return navigateToBankList()
            
        case let .transferAmountIsRequired(bank, accountNumber):
            return navigateToTransferAmount(bank, accountNumber)
            
        case let .transferCheckIsRequired(bank, accountNumber, amount):
            return navigateToTransferCheck(bank, accountNumber, amount)
            
        case .dismiss:
            self.rootViewController.dismiss(animated: true)
            return .none
            
        case .popViewController:
            self.rootViewController.navigationController?.popToRootViewController(animated: true)
            return .none
            
        default:
            return .none
        }
    }
}

extension TransferFlow {
    private func navigateToTransferDestination() -> FlowContributors {
        guard let nextStepper = rootViewController.reactor else { return .none }
        return .one(flowContributor: .contribute(withNextPresentable: rootViewController, withNextStepper: nextStepper))
    }
    
    private func navigateToBankList() -> FlowContributors {
        let reactor = BankListViewReactor(accountService: services.accountService)
        let viewController = BankListViewController(reactor: reactor)

        self.rootViewController.present(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTransferAmount(_ bank: Bank, _ accountNumber: String) -> FlowContributors {
        let reactor = TransferAmountViewReactor(bank: bank, accountNumber: accountNumber)
        let viewController = TransferAmountViewController(reactor: reactor)
        
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTransferCheck(_ bank: Bank, _ accountNumber: String, _ amount: Int) -> FlowContributors {
        let reactor = TransferCheckViewReactor(bank: bank,
                                               accountNumber: accountNumber,
                                               amount: amount,
                                               bankAccount: self.bankAccount,
                                               accountService: services.accountService)
        let viewController = TransferCheckViewController(reactor: reactor)

        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
