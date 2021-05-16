//
//  TotalAccountViewSection.swift
//  Pass
//
//  Created by 강민석 on 2021/05/14.
//

import RxDataSources

enum TotalAccountViewSection {
    case account([TotalAccountViewSectionItem])
    case add([TotalAccountViewSectionItem])
}

extension TotalAccountViewSection: SectionModelType {
    typealias Item = TotalAccountViewSectionItem
    
    var items: [TotalAccountViewSectionItem] {
        switch self {
        case let .account(items):
            return items
            
        case let .add(items):
            return items
        }
    }
    
    init(original: TotalAccountViewSection, items: [TotalAccountViewSectionItem]) {
        switch original {
        case .account:
            self = .account(items)
            
        case .add:
            self = .add(items)
        }
    }
}

enum TotalAccountViewSectionItem {
    case account(AccountCellReactor) // 계좌 셀
    case addAccount // 계좌 추가 셀
}
