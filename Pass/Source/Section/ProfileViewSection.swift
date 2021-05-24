//
//  ProfileViewSection.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import RxDataSources

enum ProfileViewSection {
    case profile([ProfileViewSectionItem])
}

extension ProfileViewSection: SectionModelType {
    var items: [ProfileViewSectionItem] {
        switch self {
        case let .profile(items): return items
        }
    }
    
    init(original: ProfileViewSection, items: [ProfileViewSectionItem]) {
        switch original {
        case .profile: self = .profile(items)
        }
    }
}

enum ProfileViewSectionItem {
    case avatar(ProfileAvatarItemCellReactor)
    case name(ProfileItemCellReactor)
    case phone(ProfileItemCellReactor)
    case email(ProfileItemCellReactor)
}
