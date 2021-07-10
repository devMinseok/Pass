//
//  ProfileHeaderViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class ProfileHeaderViewReactor: Reactor {
    
    var steps: PublishRelay<Step>?
    
    enum Action {
        case refresh
        case transfer
    }
    
    enum Mutation {
        case userData(User?)
    }
    
    struct State {
        var name: String = ""
        var profileImage: URL?
    }
    
    let initialState: State = State()
    
    fileprivate let userService: UserServiceType
    
    init(
        userService: UserServiceType
    ) {
        self.userService = userService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return self.userService.currentUser
                .map(Mutation.userData)
            
        case .transfer:
            self.steps?.accept(PassStep.transferIsRequired(BankAccount(idx: 1,
                                                                       ownerIdx: 2,
                                                                       bank: Bank(idx: 1, bankName: "농협", logoURL: URL(string: "https://image.shinhan.com/rib2017/images/any/img_mobile_logo.png?dt=1621247227131")!),
                                                                       balance: 4000,
                                                                       accountNumber: "3120194627011",
                                                                       accountNickname: "NH")))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .userData(user):
            guard let user = user else { return state }
            state.name = user.name
            state.profileImage = user.avatar
        }
        
        return state
    }
}
