//
//  TransferCheckViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/06/01.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow
import SwiftMessages

final class TransferCheckViewReactor: Reactor, Stepper {
    
    var steps = PublishRelay<Step>()
    
    enum Action {
        case send
    }
    
    enum Mutation {
        case setLoading(Bool)
    }
    
    struct State {
        let bank: Bank
        let accountNumber: String
        let amount: Int
        var bankAccount: BankAccount?
        
        var isLoading: Bool = false
    }
    
    let initialState: State
    fileprivate let accountService: AccountServiceType
    
    init(
        bank: Bank,
        accountNumber: String,
        amount: Int,
        bankAccount: BankAccount?,
        accountService: AccountServiceType
    ) {
        self.accountService = accountService
        
        self.initialState = State(bank: bank,
                                  accountNumber: accountNumber,
                                  amount: amount,
                                  bankAccount: bankAccount)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .send:
            guard let withdrawalAccountNumber = self.currentState.bankAccount?.accountNumber else {
                return Observable.empty()
            }
            
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                
                self.accountService.transfer(
                    self.currentState.accountNumber,
                    withdrawalAccountNumber: withdrawalAccountNumber,
                    amount: self.currentState.amount
                )
                .asObservable()
                .map { true }.catchErrorJustReturn(false)
                .do { isSuccess in
                    if isSuccess {
                        self.steps.accept(PassStep.popViewController)
                    } else {
                        SwiftMessages.show(config: Message.passConfig, view: Message.faildView("송금 실패"))
                    }
                }.flatMap { _ in Observable.empty() },
                
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }
        
        return state
    }
}
