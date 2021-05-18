//
//  AccountHistoryCellReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/18.
//

import ReactorKit

final class AccountHistoryCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var date: String
        var name: String
        var timePlatform: String
        var amount: Int
        var balance: String
    }
    
    var initialState: State
    
    init(accountHistory: AccountHistory) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM.dd"
        let month = dateFormatter.string(from: accountHistory.date)
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: accountHistory.date)
        
        let timePlatform = "\(time) | \(accountHistory.platformName)"
        
        self.initialState = State(
            date: month,
            name: accountHistory.targetName,
            timePlatform: timePlatform,
            amount: accountHistory.amount,
            balance: accountHistory.balance.decimalWon()
        )
    }
}
