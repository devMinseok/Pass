//
//  SplashViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/03/19.
//

import ReactorKit
import RxSwift
import RxCocoa

final class SplashViewReactor: Reactor {
    typealias Action = NoAction
    
    struct State { }
    
    let initialState: State = State()
}
