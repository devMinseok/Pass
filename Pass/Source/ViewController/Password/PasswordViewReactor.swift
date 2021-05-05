//
//  PasswordViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/01.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class PasswordViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    enum Action {
        case callBack(String)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .callBack(password):
            inputPassword.onNext(password)
            self.steps.accept(PassStep.dismiss)
            return .empty()
        }
    }
}
