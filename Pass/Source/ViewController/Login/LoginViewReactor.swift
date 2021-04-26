//
//  LoginViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/04/13.
//

import ReactorKit
import RxSwift
import RxCocoa

class LoginViewReactor: Reactor {
    enum Action {
        case login
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setLoggedIn(Bool)
    }
    
    struct State {
        var isLoading: Bool = false
        var isLoggedIn: Bool = false
    }
    
    let initialState: State = State()
    
    fileprivate let userService: UserServiceType
    fileprivate let authService: AuthServiceType
    
    init(authService: AuthServiceType, userService: UserServiceType) {
        self.authService = authService
        self.userService = userService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
//        case .signup:
//            let setLoading = Observable.just(Mutation.setLoading(true))
//            let setLoggedIn = self.authService.signup()
//                .asObservable()
//                .flatMap { self.userService.fetchUser() }
//                .map { true }
//                .catchErrorJustReturn(false)
//                .map(Mutation.setLoggedIn)
//            return setLoading.concat(setLoggedIn)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
        case let .setLoggedIn(isLoggedIn):
            state.isLoggedIn = isLoggedIn
            return state
        }
    }
}

