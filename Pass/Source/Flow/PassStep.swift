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
    
    // MARK: - 은행 리스트
    case bankListIsRequired
    
    // MARK: - 송금
    case transferIsRequired(BankAccount?) // 출금계좌
    case transferDestinationIsRequired
    case transferAmountIsRequired(Bank, String) // 받는 사람 은행, 계좌번호
    case transferCheckIsRequired(Bank, String, Int) // 받는 사람 은행, 계좌번호, 금액
}
