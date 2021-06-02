//
//  AccountViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class AccountViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case refresh
    }

    enum Mutation {
        case setAccountCells([AccountHistory])
        case setRefreshing(Bool)
    }

    struct State {
        var bankAccount: BankAccount
        
        var isRefreshing: Bool = false
        var items: [AccountHistory] = []
    }

    let initialState: State
    fileprivate let accountService: AccountServiceType
    
    let accountViewHeaderReactor: AccountViewHeaderReactor
    
    init(
        accountService: AccountServiceType,
        bankAccount: BankAccount
    ) {
        self.accountService = accountService
        self.initialState = State(bankAccount: bankAccount)
        
        self.accountViewHeaderReactor = .init(bankAccount: bankAccount)
        self.accountViewHeaderReactor.steps = self.steps
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                Observable<Mutation>.just(Mutation.setRefreshing(true)),
                
                self.accountService.getAccountHistory(currentState.bankAccount.idx)
                    .asObservable()
                    .map(Mutation.setAccountCells),
                
                Observable<Mutation>.just(Mutation.setRefreshing(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setAccountCells(accountHistory):
            state.items = accountHistory
            
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        }
        
        return state
    }
}
