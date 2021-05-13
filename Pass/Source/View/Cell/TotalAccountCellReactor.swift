//
//  TotalAccountCellReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import ReactorKit

final class TotalAccountCellReactor: Reactor {
    typealias Action = NoAction
    struct State {
        var bankAccounts: [BankAccount]
        var title: String?
        var balance: String?
    }
    
    let initialState: State
    
    init(bankAccounts: [BankAccount]) {
        let totalBalance = bankAccounts.reduce(0) { $0 + $1.balance }
        self.initialState = State(
            bankAccounts: bankAccounts,
            title: "계좌",
            balance: totalBalance.decimalWon()
        )
        _ = self.state
    }
}
