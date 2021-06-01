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
        
    }
    
    struct State {
        let bank: Bank
        let accountNumber: String
        let amount: Int
        var bankAccount: BankAccount?
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
            
            return self.accountService.transfer(
                self.currentState.accountNumber,
                withdrawalAccountNumber: withdrawalAccountNumber,
                amount: self.currentState.amount
            )
            .asObservable()
            .do(onNext: {
                self.steps.accept(PassStep.popViewController)
            }, onError: { error in
                SwiftMessages.show(config: Message.passConfig, view: Message.faildView("송금 실패"))
            }).flatMap { _ in Observable.empty() }
        }
    }
}
