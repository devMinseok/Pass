//
//  IntroViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/04/28.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class IntroViewReactor: Reactor, Stepper {
    
    var steps = PublishRelay<Step>()
    
    enum Action {
        case login
        case register
    }

    enum Mutation {
        case navigateToLogin
        case navigateToRegister
    }

    struct State { }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .login:
            steps.accept(PassStep.loginIsRequired)
            return .empty()
        case .register:
            steps.accept(PassStep.registerIsRequired)
            return .empty()
        }
    }
}
