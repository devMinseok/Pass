//
//  TotalAccountViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class TotalAccountViewReactor: Reactor, Stepper {
    
    var steps = PublishRelay<Step>()
    
    enum Action {
        case refresh
        case setInitialAccounts
    }
    
    enum Mutation {
        case setTotalAccountCells([BankAccount])
        case setRefreshing(Bool)
    }
    
    struct State {
        var bankAccounts: [BankAccount]
        
        var isRefreshing: Bool = false
        var accountSectionItems: [TotalAccountViewSectionItem] = []
        var addSectionItems: [TotalAccountViewSectionItem] = []
        var sections: [TotalAccountViewSection] {
            let sections: [TotalAccountViewSection] = [
                .account(self.accountSectionItems),
                .add(self.addSectionItems)
            ]
            return sections
        }
    }
    
    let initialState: State
    fileprivate let accountService: AccountServiceType
    
    init(
        accountService: AccountServiceType,
        bankAccounts: [BankAccount]
    ) {
        self.accountService = accountService
        self.initialState = State(bankAccounts: bankAccounts)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                Observable<Mutation>.just(.setRefreshing(true)),
                self.accountService.getAccounts().asObservable().map(Mutation.setTotalAccountCells),
                Observable<Mutation>.just(.setRefreshing(false))
            ])
            
        case .setInitialAccounts:
            return Observable.just(.setTotalAccountCells(self.currentState.bankAccounts))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setTotalAccountCells(bankAccounts):
            state.accountSectionItems.removeAll()
            state.addSectionItems.removeAll()
            
            // 계좌들
            bankAccounts.forEach { bankAccount in
                state.accountSectionItems.append(
                    .account(AccountCellReactor(bankAccount: bankAccount, steps: self.steps))
                )
            }
            
            // 추가
            state.addSectionItems.append(
                .addAccount
            )
            
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        }

        return state
    }
}
