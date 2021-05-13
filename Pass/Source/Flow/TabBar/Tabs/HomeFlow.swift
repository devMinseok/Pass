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
    
    private lazy var rootViewController = UINavigationController()
    
    private let authService: AuthServiceType
    private let userService: UserServiceType
    private let accountService: AccountServiceType
    
    init() {
        self.authService = DIContainer.shared.container.resolve(AuthServiceType.self)!
        self.userService = DIContainer.shared.container.resolve(UserServiceType.self)!
        self.accountService = DIContainer.shared.container.resolve(AccountServiceType.self)!
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
            
        default:
            return .none
        }
    }
}

extension HomeFlow {
    // Initial Navigate
    private func navigateToHome() -> FlowContributors {
        let reactor = HomeViewReactor(userService: userService, accountService: accountService)
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
