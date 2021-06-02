//
//  TransferAmountViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/25.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class TransferAmountViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case next(String)
    }

    enum Mutation {

    }

    struct State {
        var bank: Bank
        var accountNumber: String
        var amount: String = "0"
    }

    let initialState: State

    init(
        bank: Bank,
        accountNumber: String
    ) {
        self.initialState = State(
            bank: bank,
            accountNumber: accountNumber
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .next(amount):
            guard let amount = Int(amount) else { return .empty() }
            self.steps.accept(PassStep.transferCheckIsRequired(self.currentState.bank, self.currentState.accountNumber, amount))
            return .empty()
        }
    }
}
