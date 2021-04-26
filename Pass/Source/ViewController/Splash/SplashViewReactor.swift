//
//  SplashViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/03/19.
//

import ReactorKit
import RxSwift
import RxCocoa

class SplashViewReactor: Reactor {
    enum Action {
        case checkIfAuthenticated
    }
    
    enum Mutation {
        case setAuthenticated(Bool)
    }
    
    struct State {
        var isAuthenticated: Bool?
    }
    
    let initialState = State()
    
    fileprivate let userService: UserServiceType
    
    init(userService: UserServiceType) {
        self.userService = userService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkIfAuthenticated:
            return self.userService.fetchUser()
                .asObservable()
                .map { true }
                .catchErrorJustReturn(false)
                .map(Mutation.setAuthenticated)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setAuthenticated(isAuthenticated):
            state.isAuthenticated = isAuthenticated
            return state
        }
    }
}
