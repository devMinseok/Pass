//
//  AccountCell.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import UIKit

import ReactorKit

final class AccountCell: BaseTableViewCell, View {
    
    typealias Reactor = AccountCellReactor
    
    // MARK: Constants
    struct Font {
        static let textLabel = UIFont.systemFont(ofSize: 13, weight: .light)
        static let detailTextLabel = UIFont.systemFont(ofSize: 17, weight: .medium)
        static let buttonTitleLabel = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }

    // MARK: - UI
    fileprivate let transferButton = PassPlainButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30)).then {
        $0.setTitle("송금", for: .normal)
        $0.titleLabel?.font = Font.buttonTitleLabel
        $0.setTitleColor(R.color.textAccent(), for: .normal)
        $0.backgroundColor = R.color.smallButton()
        $0.layer.cornerRadius = 6
    }

    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        
        self.contentView.addSubview(self.transferButton)
        
        self.textLabel?.font = Font.textLabel
        self.textLabel?.textColor = .darkGray
        self.detailTextLabel?.font = Font.detailTextLabel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.accessoryView = transferButton
        
        self.textLabel?.frame.origin.x -= 35
        self.detailTextLabel?.frame.origin.x -= 35
        
        self.imageView?.clipsToBounds = true
        self.imageView?.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        self.imageView?.layer.cornerRadius = 33 * 0.5
        self.imageView?.center = CGPoint(x: 36, y: self.contentView.bounds.size.height / 2)
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        transferButton.rx.tap
            .map { Reactor.Action.transfer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state
            .subscribe(onNext: { [weak self] state in
                self?.imageView?.kf.setImage(with: state.bankLogoUrl) { _ in self?.setNeedsLayout() }
                self?.textLabel?.text = state.bankName
                self?.detailTextLabel?.text = state.balance
            })
            .disposed(by: disposeBag)
    }
}
