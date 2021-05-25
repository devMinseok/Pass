//
//  ProfileAvatarItemCellReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import ReactorKit
import RxCocoa

final class ProfileAvatarItemCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var avatarURL: URL
    }
    
    let initialState: State
    
    init(avatarURL: URL) {
        self.initialState = State(avatarURL: avatarURL)
        _ = self.state
    }
}
