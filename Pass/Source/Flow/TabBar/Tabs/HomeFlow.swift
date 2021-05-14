//
//  HomeFlow.swift
//  Pass
//
//  Created by 강민석 on 2021/04/27.
//

import RxFlow

final class HomeFlow: Flow {
    
    // MARK: - Properties
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController = UINavigationController().then {
        $0.navigationBar.backgroundColor = R.color.signatureColor()
        $0.navigationBar.shadowImage = UIImage()
        $0.navigationBar.isTranslucent = true
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
        // 홈 화면
        case .homeIsRequired:
            return self.navigateToHome()
            
        case let .accountIsRequired(bankAccount):
            return self.navigateToAccount(bankAccount)
            
        case let .totalAccountsIsRequired(bankAccounts):
            return self.navigateToTotalAccount(bankAccounts)
            
        case .addAccountIsRequired:
            return self.navigateToAddAccount()
            
        case let .transferIsRequired(withdrawal):
            return self.navigateToTransfer(withdrawal)
            
        case .profileIsRequried:
            return self.navigateToProfile()
            
        default:
            return .none
        }
    }
}

extension HomeFlow {
    // Initial Navigate
    private func navigateToHome() -> FlowContributors {
        let profileHeaderViewReactor = ProfileHeaderViewReactor(userService: services.userService)
        
        let reactor = HomeViewReactor(userService: services.userService, accountService: services.accountService, profileHeaderViewReactor: profileHeaderViewReactor)
        let viewController = HomeViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToAccount(_ bankAccount: BankAccount) -> FlowContributors {
        let reactor = AccountViewReactor()
        let viewController = AccountViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTotalAccount(_ bankAccounts: [BankAccount]) -> FlowContributors {
        let reactor = TotalAccountViewReactor()
        let viewController = TotalAccountViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToProfile() -> FlowContributors {
        let reactor = ProfileViewReactor()
        let viewController = ProfileViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
    
    private func navigateToAddAccount() -> FlowContributors {
        // 계좌 추가 Flow를 만들어야함
        let reactor = AddAccountViewReactor()
        let viewController = AddAccountViewController(reactor: reactor)
        
        return .none
    }
    
    private func navigateToTransfer(_ withdrawal: BankAccount?) -> FlowContributors {
        // 송금 Flow를 만들어야함
        let reactor = TransferViewReactor()
        let viewController = TransferViewController(reactor: reactor)
        
        return .none
    }
}
