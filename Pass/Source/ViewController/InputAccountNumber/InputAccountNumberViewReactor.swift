//
//  InputAccountNumberViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/06/02.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow
import SwiftMessages

final class InputAccountNumberViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case setAccountNumber(String)
        case next
        case addAccount(String)
    }

    enum Mutation {
        case checkAccountNumber(String)
        case setLoading(Bool)
    }

    struct State {
        var bank: Bank
        var accountNumber: String = ""
        var accountNumberValidation: ValidationResult?
        var isLoading: Bool = false
    }

    let initialState: State
    
    fileprivate let accountService: AccountServiceType

    init(
        accountService: AccountServiceType,
        bank: Bank
    ) {
        self.accountService = accountService
        self.initialState = State(bank: bank)
    }
    
    // PasswordViewController 비밀번호 입력 완료 이벤트 처리
    func transform(action: Observable<Action>) -> Observable<Action> {
        return Observable.merge(action, inputPassword.map(Action.addAccount))
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .next:
            self.steps.accept(PassStep.passwordIsRequired)
            return Observable.empty()
            
        case let .setAccountNumber(accountNumber):
            return Observable.just(Mutation.checkAccountNumber(accountNumber))
            
        case let .addAccount(accountPassword):
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                
                self.accountService.addAccount(self.currentState.bank.idx, self.currentState.accountNumber, accountPassword)
                    .asObservable()
                    .map { true }.catchErrorJustReturn(false)
                    .do { isSuccess in
                        if isSuccess {
                            SwiftMessages.show(config: Message.passConfig, view: Message.successView("계좌 추가 완료"))
                            self.steps.accept(PassStep.popViewController)
                        } else {
                            SwiftMessages.show(config: Message.passConfig, view: Message.faildView("계좌 추가 실패"))
                        }
                    }.flatMap { _ in Observable.empty() },
                
                Observable.just(Mutation.setLoading(true))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .checkAccountNumber(accountNumber):
            state.accountNumber = accountNumber
            state.accountNumberValidation = accountNumber.validAccountNumber
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }

        return state
    }

}
