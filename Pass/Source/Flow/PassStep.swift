//
//  PassStep.swift
//  Pass
//
//  Created by 강민석 on 2021/04/26.
//

import RxFlow

enum PassStep: Step {
    
    // MARK: - Splash
    case splashIsRequired
    case introIsRequired
    case mainTabBarIsRequired
    
    // MARK: - Intro
    case loginIsRequired
    case registerIsRequired
    
    case passwordIsRequired
    
    case homeIsRequired
    case myConsumeIsRequired
    case settingsIsRequired
}
