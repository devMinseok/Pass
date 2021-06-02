//
//  BankListViewSection.swift
//  Pass
//
//  Created by 강민석 on 2021/05/25.
//

import RxDataSources

enum BankListViewSection {
    case bankCell([BankListViewSectionItem])
}

extension BankListViewSection: SectionModelType {
    var items: [BankListViewSectionItem] {
        switch self {
        case let .bankCell(items): return items
        }
    }
    
    init(original: BankListViewSection, items: [BankListViewSectionItem]) {
        switch original {
        case .bankCell: self = .bankCell(items)
        }
    }
    
}

enum BankListViewSectionItem {
    case bankCell(BankListCellReactor)
}
