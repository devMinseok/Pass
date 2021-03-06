//
//  BankListViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class BankListViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case refresh
    }

    enum Mutation {
        case setBankList([Bank])
        case setLoading(Bool)
    }

    struct State {
        var sections: [BankListViewSection] = [.bankCell([])]
        var isLoading: Bool = false
    }

    let initialState: State = State()
    fileprivate let accountService: AccountServiceType

    init(
        accountService: AccountServiceType
    ) {
        self.accountService = accountService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.accountService.getBankList().asObservable().map(Mutation.setBankList),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setBankList(bankList):
            var sectionItems = [BankListViewSectionItem]()
            bankList.forEach { bank in
                sectionItems.append(BankListViewSectionItem.bankCell(BankListCellReactor(bank: bank)))
            }
            
            state.sections = [
                .bankCell(sectionItems)
            ]
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }

        return state
    }
}
