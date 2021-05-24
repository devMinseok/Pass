//
//  AccountViewHeaderReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/18.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class AccountViewHeaderReactor: Reactor {
    
    var steps: PublishRelay<Step>?
    
    enum Action {
        case transfer
    }
    
    enum Mutation { }
    
    struct State {
        var bankAccount: BankAccount
        var accountNumber: String
        var balance: String
    }
    
    let initialState: State
    
    init(
        bankAccount: BankAccount
    ) {
        self.initialState = State(
            bankAccount: bankAccount,
            accountNumber: "\(bankAccount.bank.bankName) \(bankAccount.accountNumber)",
            balance: bankAccount.balance.decimalWon()
        )
        _ = self.state
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .transfer:
            self.steps?.accept(PassStep.transferIsRequired(self.currentState.bankAccount))
            return .empty()
        }
    }
}
