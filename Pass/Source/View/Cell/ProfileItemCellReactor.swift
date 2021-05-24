//
//  ProfileItemCellReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import ReactorKit
import RxCocoa

final class ProfileItemCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var text: String
        var detailText: String
    }
    
    let initialState: State
    
    init(text: String, detailText: String) {
        self.initialState = State(text: text, detailText: detailText)
        _ = self.state
    }
}
