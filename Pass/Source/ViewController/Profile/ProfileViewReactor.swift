//
//  ProfileViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class ProfileViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case refresh
    }

    enum Mutation {
        case setProfile(User?)
    }

    struct State {
        var sections: [ProfileViewSection] = []
    }

    let initialState: State = State()
    fileprivate let userService: UserServiceType

    init(userService: UserServiceType) {
        self.userService = userService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return self.userService.currentUser.asObservable().map(Mutation.setProfile)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setProfile(user):
            guard let user = user else { return state }
            
            let items = ProfileViewSection.profile([
                .avatar(ProfileAvatarItemCellReactor(avatarURL: user.avatar)),
                .name(ProfileItemCellReactor(text: "이름", detailText: user.name)),
                .phone(ProfileItemCellReactor(text: "전화번호", detailText: user.phone)),
                .email(ProfileItemCellReactor(text: "이메일", detailText: user.email))
            ])
            
            state.sections = [items]
        }

        return state
    }
}
