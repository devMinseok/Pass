//
//  SplashViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/03/19.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow
import SwiftMessages

final class SplashViewReactor: Reactor, Stepper {
    
    var steps = PublishRelay<Step>()
    
    enum Action {
        case branchView
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State = State()
    fileprivate let authService: AuthServiceType
    fileprivate let userService: UserServiceType
    
    let errorRelay = PublishRelay<Error>()
    
    init(
        authService: AuthServiceType,
        userService: UserServiceType
    ) {
        self.authService = authService
        self.userService = userService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .branchView:
            if self.authService.currentToken == nil {
                self.steps.accept(PassStep.introIsRequired)
                return Observable.empty()
            }
            
            return self.userService.fetchUser()
                .asObservable()
                .do { _ in
                    self.steps.accept(PassStep.mainTabBarIsRequired)
                } onError: { error in
                    self.steps.accept(PassStep.introIsRequired)
                    SwiftMessages.show(config: Message.passConfig, view: Message.faildView("토큰이 만료되었습니다. 다시로그인해주세요"))
                }.flatMap { _ in Observable.empty() }
        }
    }
}
