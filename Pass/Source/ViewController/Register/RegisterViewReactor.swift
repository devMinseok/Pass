//
//  RegisterViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/04/26.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow
import SwiftMessages

final class RegisterViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    var phone, email, name: String?
    
    enum Action {
        case setFields([String])
        case next
        
        case register(String)
    }
    
    enum Mutation {
        case checkFields([String])
        case setLoading(Bool)
    }
    
    struct State {
        var isLoading: Bool = false
        var isButtonEnabled: Bool = false
        var phoneValidationResult: ValidationResult?
        var emailValidationResult: ValidationResult?
        var nameValidationResult: ValidationResult?
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
        return Observable.merge(action, inputPassword.map(Action.register))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setFields(fields): // phone, email, name
            self.phone = fields[0]
            self.email = fields[1]
            self.name = fields[2]
            return Observable.just(Mutation.checkFields(fields))
            
        case .next:
            self.steps.accept(PassStep.passwordIsRequired)
            return .empty()
            
        case let .register(password):
            guard let phone = phone,
                  let email = email,
                  let name = name
            else { return .empty() }
            
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                
                self.authService.register(password, name, email, phone)
                    .asObservable()
                    .flatMap { self.userService.fetchUser() }
                    .map { true }.catchErrorJustReturn(false)
                    .do { isRegisteredIn in
                        if isRegisteredIn {
                            SwiftMessages.show(config: Message.passConfig, view: Message.successView("회원가입 성공"))
                            self.steps.accept(PassStep.mainTabBarIsRequired)
                        } else {
                            SwiftMessages.show(config: Message.passConfig, view: Message.faildView("회원가입 실패"))
                        }
                    }.flatMap { _ in Observable.empty() },
                
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .checkFields(fields):
            let isValidPhone = fields[0].validPhone
            let isValidEmail = fields[1].validEmail
            let isValidName = fields[2].validName
            
            var isPhone = false
            var isEmail = false
            var isName = false
            
            switch isValidPhone {
            case .ok: isPhone = true
            case .no: isPhone = false
            }
            
            switch isValidEmail {
            case .ok: isEmail = true
            case .no: isEmail = false
            }
            
            switch isValidName {
            case .ok: isName = true
            case .no: isName = false
            }
            
            state.phoneValidationResult = isValidPhone
            state.emailValidationResult = isValidEmail
            state.nameValidationResult = isValidName
            state.isButtonEnabled = isPhone && isEmail && isName
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }
        
        return state
    }
}
