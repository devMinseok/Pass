//
//  HomeViewSection.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import RxDataSources

enum HomeViewSection {
    case account([HomeViewSectionItem])
    case add([HomeViewSectionItem])
}

extension HomeViewSection: SectionModelType {
    typealias Item = HomeViewSectionItem
    
    var items: [HomeViewSectionItem] {
        switch self {
        case let .account(items):
            return items
            
        case let .add(items):
            return items
        }
    }
    
    init(original: HomeViewSection, items: [HomeViewSectionItem]) {
        switch original {
        case .account:
            self = .account(items)
            
        case .add:
            self = .add(items)
        }
    }
}

enum HomeViewSectionItem {
    case totalAccount(TotalAccountCellReactor) // 총 계좌 화면 셀
    case account(AccountCellReactor) // 계좌 셀
    
    case addAccount // 계좌 추가 셀
}
