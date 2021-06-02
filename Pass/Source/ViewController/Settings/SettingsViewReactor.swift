//
//  SettingsViewReactor.swift
//  Pass
//
//  Created by 강민석 on 2021/04/26.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class SettingsViewReactor: Reactor, Stepper {
    
    var steps = PublishRelay<Step>()
    
    enum Action {
        case logout
        case myInfo
        case github
        case version
    }
    
    struct State {
        var sections: [SettingsViewSection] = []
        
        init(sections: [SettingsViewSection]) {
            self.sections = sections
        }
    }
    
    let initialState: State
    
    fileprivate let authService: AuthServiceType
    
    init(
        authService: AuthServiceType
    ) {
        self.authService = authService
        
        let settingSection = SettingsViewSection.setting([
            .myInfo(SettingItemCellReactor(text: "내 정보", detailText: nil)),
            .github(SettingItemCellReactor(text: "Pass Github", detailText: "devMinseok/Pass")),
            .version(SettingItemCellReactor(text: "버전 정보", detailText: nil)),
            .logout(SettingItemCellReactor(text: "로그아웃", detailText: "개인 정보와 설정이 모두 삭제됩니다."))
        ])
        
        self.initialState = State(sections: [settingSection])
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .logout:
            self.authService.logout()
            self.steps.accept(PassStep.introIsRequired)
            return Observable.empty()
            
        case .myInfo:
            self.steps.accept(PassStep.profileIsRequried)
            return Observable.empty()
            
        case .github:
            self.steps.accept(PassStep.githubIsRequired)
            return Observable.empty()
            
        case .version:
            self.steps.accept(PassStep.versionIsRequired)
            return Observable.empty()
        }
    }
}
