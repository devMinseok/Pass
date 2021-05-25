//
//  ProfileItemCell.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import UIKit

import ReactorKit

final class ProfileItemCell: BaseTableViewCell, View {
    
    typealias Reactor = ProfileItemCellReactor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    func bind(reactor: Reactor) {
        reactor.state
            .subscribe(onNext: { [weak self] state in
                self?.textLabel?.text = state.text
                self?.detailTextLabel?.text = state.detailText
            })
            .disposed(by: disposeBag)
    }
}
