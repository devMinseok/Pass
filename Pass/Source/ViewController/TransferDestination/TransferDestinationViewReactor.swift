//
//  TransferDestinationViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow
import SwiftMessages

final class TransferDestinationViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case showBankList
        case bankIsSelected(Bank)
        case setAccountNumber(String)
        case next
    }

    enum Mutation {
        case setBank(Bank)
        case checkAccountNumber(String)
    }

    struct State {
        var bank: Bank?
        var accountNumber: String = ""
        
        var accountNumberValidation: ValidationResult?
    }

    let initialState: State = State()
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return Observable.merge(action, selectedBank.map(Action.bankIsSelected))
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .showBankList:
            self.steps.accept(PassStep.bankListIsRequired)
            return .empty()
            
        case let .setAccountNumber(accountNumber):
            return Observable.just(Mutation.checkAccountNumber(accountNumber))
            
        case .next:
            guard let bank = self.currentState.bank else {
                SwiftMessages.show(config: Message.passConfig, view: Message.faildView("은행을 선택해주세요"))
                return .empty()
            }
            
            self.steps.accept(
                PassStep.transferAmountIsRequired(bank, self.currentState.accountNumber)
            )
            return .empty()
            
        case let .bankIsSelected(bank):
            return Observable.just(Mutation.setBank(bank))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .checkAccountNumber(accountNumber):
            state.accountNumber = accountNumber
            state.accountNumberValidation = accountNumber.validAccountNumber
            
        case let .setBank(bank):
            state.bank = bank
        }

        return state
    }
}
