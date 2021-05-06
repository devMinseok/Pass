//
//  LoginViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/04/30.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow
import SwiftMessages

final class LoginViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    var email: String?
    
    enum Action {
        case setEmail(String)
        case next(String)
        
        case login(String)
    }
    
    enum Mutation {
        case checkEmail(String)
        case setLoading(Bool)
    }
    
    struct State {
        var validationResult: ValidationResult?
        var isLoading: Bool = false
    }
    
    let initialState: State = State()
    
    fileprivate let authService: AuthServiceType
    fileprivate let userService: UserServiceType
    
    init(authService: AuthServiceType, userService: UserServiceType) {
        self.authService = authService
        self.userService = userService
    }
    
    // global sate 처리
    func transform(action: Observable<Action>) -> Observable<Action> {
        return Observable.merge(action, inputPassword.map(Action.login))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setEmail(email):
            return Observable.just(Mutation.checkEmail(email))
            
        case let .next(email):
            self.email = email
            self.steps.accept(PassStep.passwordIsRequired)
            return .empty()
            
        case let .login(password):
            guard let email = email else { return .empty() }
            
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                
                self.authService.login(email, password)
                    .flatMap { self.userService.fetchUser() }
                    .map { true }.catchErrorJustReturn(false)
                    .do { isLoggedIn in
                        if isLoggedIn {
                            SwiftMessages.show(config: Message.passConfig, view: Message.successView("로그인 성공"))
                            self.steps.accept(PassStep.mainTabBarIsRequired)
                        } else {
                            SwiftMessages.show(config: Message.passConfig, view: Message.faildView("로그인 실패"))
                        }
                    }.flatMap { _ in Observable.empty() },
                
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .checkEmail(email):
            state.validationResult = email.validEmail
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }
        
        return state
    }
}
