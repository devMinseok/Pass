//
//  SettingsViewSection.swift
//  Pass
//
//  Created by 강민석 on 2021/06/02.
//

import RxDataSources

enum SettingsViewSection {
    case setting([SettingsViewSectionItem])
}

extension SettingsViewSection: SectionModelType {
    var items: [SettingsViewSectionItem] {
        switch self {
        case .setting(let items): return items
        }
    }
    
    init(original: SettingsViewSection, items: [SettingsViewSectionItem]) {
        switch original {
        case .setting: self = .setting(items)
        }
    }
}

enum SettingsViewSectionItem {
    case myInfo(SettingItemCellReactor)
    case version(SettingItemCellReactor)
    case github(SettingItemCellReactor)
    case logout(SettingItemCellReactor)
}
