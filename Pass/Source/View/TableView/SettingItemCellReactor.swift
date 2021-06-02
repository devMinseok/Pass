//
//  SettingItemCellReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/06/02.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SettingItemCellReactor: Reactor {
    typealias Action = NoAction
    struct State {
        var text: String?
        var detailText: String?
    }
    
    let initialState: State
    
    init(text: String?, detailText: String?) {
        self.initialState = State(text: text, detailText: detailText)
        _ = self.state
    }
}
