//
//  PassStep.swift
//  Pass
//
//  Created by 강민석 on 2021/04/26.
//

import RxFlow

enum PassStep: Step {
    
    case popViewController
    case dismiss
    
    // MARK: - Splash
    case splashIsRequired
    case introIsRequired
    case mainTabBarIsRequired
    
    // MARK: - Intro
    case loginIsRequired
    case registerIsRequired
    
    case passwordIsRequired
    
    // MARK: - 홈
    case homeIsRequired
    case totalAccountsIsRequired([BankAccount]) // 계좌들
    case accountIsRequired(BankAccount) // 계좌
    case addAccountIsRequired
    case profileIsRequried
    
    // MARK: - 내 소비
    case myConsumeIsRequired
    
    // MARK: - 설정
    case settingsIsRequired
    
    // MARK: - 송금
    case transferIsRequired(BankAccount? = nil) // 출금계좌 번호
    case transferDestinationIsRequired
    case transferAmountIsRequired
}
