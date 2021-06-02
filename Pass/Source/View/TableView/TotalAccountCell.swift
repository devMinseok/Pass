//
//  TotalAccountCell.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import RxSwift
import ReactorKit

final class TotalAccountCell: BaseTableViewCell, View {
    
    typealias Reactor = TotalAccountCellReactor
    
    // MARK: - Constants
    struct Font {
        static let textLabel = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let detailTextLabel = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    // MARK: - UI
    
    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        
        self.textLabel?.font = Font.textLabel
        self.detailTextLabel?.font = Font.detailTextLabel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Configuring
    func bind(reactor: TotalAccountCellReactor) {
        reactor.state
            .subscribe(onNext: { [weak self] state in
                self?.textLabel?.text = state.title
                self?.detailTextLabel?.text = state.balance
            })
            .disposed(by: disposeBag)
    }
    
}
