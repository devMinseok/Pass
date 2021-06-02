//
//  BankListCellReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/25.
//

import ReactorKit
import RxCocoa
import RxSwift

class BankListCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var bankLogoURL: URL
        var bankName: String
    }
    
    let bank: Bank
    let initialState: State
    
    init(bank: Bank) {
        self.bank = bank
        self.initialState = State(
            bankLogoURL: bank.logoURL,
            bankName: bank.bankName
        )
        _ = self.state
    }
}
