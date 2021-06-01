//
//  AccountService.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import RxSwift

protocol AccountServiceType {
    func getAccounts() -> Single<[BankAccount]>
    func getAccountHistory(_ accountIdx: Int) -> Single<[AccountHistory]>
    func getBankList() -> Single<[Bank]>
    func transfer(_ depositAccountNumber: String, withdrawalAccountNumber: String, amount: Int) -> Single<Void>
}

final class AccountService: AccountServiceType {
    fileprivate let network: Network<PassAPI>
    
    init(network: Network<PassAPI>) {
        self.network = network
    }
    
    func getAccounts() -> Single<[BankAccount]> {
        return self.network.requestArray(.getMyAccounts, type: BankAccount.self)
    }
    
    func getAccountHistory(_ accountIdx: Int) -> Single<[AccountHistory]> {
        return self.network.requestArray(.getAccountHistory(accountIdx), type: AccountHistory.self)
    }
    
    func getBankList() -> Single<[Bank]> {
        return self.network.requestArray(.getBankList, type: Bank.self)
    }
    
    func transfer(_ depositAccountNumber: String, withdrawalAccountNumber: String, amount: Int) -> Single<Void> {
        return self.network.requestWithoutMapping(.transfer(depositAccountNumber, withdrawalAccountNumber, amount))
    }
}
