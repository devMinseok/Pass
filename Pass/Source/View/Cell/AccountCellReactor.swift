//
//  AccountCellReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import ReactorKit
import RxCocoa
import RxFlow

final class AccountCellReactor: Reactor {
    let steps: PublishRelay<Step>
    
    enum Action {
        case transfer
    }
    
    struct State {
        var bankAccount: BankAccount
        var bankLogoUrl: URL?
        var bankName: String
        var balance: String
    }
    
    let initialState: State
    
    init(bankAccount: BankAccount, steps: PublishRelay<Step>) {
        self.initialState = State(
            bankAccount: bankAccount,
            bankLogoUrl: bankAccount.bank.thumbnail,
            bankName: bankAccount.accountNickname,
            balance: bankAccount.balance.decimalWon()
        )
        self.steps = steps
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .transfer:
            self.steps.accept(PassStep.transferIsRequired(self.currentState.bankAccount))
            return .empty()
        }
    }
}
