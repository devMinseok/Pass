//
//  HomeViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/06.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class HomeViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    enum Action {
        case refresh
    }

    enum Mutation {
        case setHomeCells([BankAccount])
        case setRefreshing(Bool)
    }

    struct State {
        var isRefreshing: Bool = false
        var accountSectionItems: [HomeViewSectionItem] = []
        var addSectionItems: [HomeViewSectionItem] = []
        var sections: [HomeViewSection] {
            let sections: [HomeViewSection] = [
                .account(self.accountSectionItems),
                .add(self.addSectionItems)
            ]
            return sections
        }
    }

    let initialState: State = State()
    
    fileprivate let userService: UserServiceType
    fileprivate let accountService: AccountServiceType
    
    let profileHeaderViewReactor: ProfileHeaderViewReactor

    init(
        userService: UserServiceType,
        accountService: AccountServiceType,
        profileHeaderViewReactor: ProfileHeaderViewReactor
    ) {
        self.userService = userService
        self.accountService = accountService
        self.profileHeaderViewReactor = profileHeaderViewReactor
        profileHeaderViewReactor.steps = steps
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                Observable<Mutation>.just(.setRefreshing(true)),
                
                self.accountService.getAccounts().asObservable().map(Mutation.setHomeCells),
                
                Observable<Mutation>.just(.setRefreshing(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setHomeCells(bankAccounts):
            state.accountSectionItems.removeAll()
            state.addSectionItems.removeAll()
            
            // 총계좌
            state.accountSectionItems.append(
                .totalAccount(TotalAccountCellReactor(bankAccounts: bankAccounts))
            )
            
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
