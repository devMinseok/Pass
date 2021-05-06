//
//  HomeViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/06.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

//final class HomeViewReactor: Reactor, Stepper {
//
//    enum Action {
//
//    }
//
//    enum Mutation {
//
//    }
//
//    struct State {
//
//    }
//
//    let initialState: State
//
//    init() {
//
//    }
//
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case <#pattern#>:
//            <#code#>
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        var state = state
//
//        switch mutation {
//        case <#pattern#>:
//            <#code#>
//        }
//
//        return state
//    }
//
//}

final class HomeViewReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
    }
    
    let initialState: State = State()
}
