//
//  AccountHistoryCell.swift
//  Pass
//
//  Created by 강민석 on 2021/05/17.
//

import UIKit

import ReactorKit

final class AccountHistoryCell: BaseTableViewCell, View {
    
    typealias Reactor = AccountHistoryCellReactor
    
    // MARK: - Constants
    struct Metric  {
        static let leftRightPadding = 20.f
        static let topBottomPadding = 10.f
    }
    
    struct Font {
        static let textLabel = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let detailTextLabel = UIFont.systemFont(ofSize: 13, weight: .light)
    }
    
    // MARK: - UI
    fileprivate let dateLabel = UILabel().then { $0.font = Font.textLabel }
    
    fileprivate let targetNameLabel = UILabel().then { $0.font = Font.textLabel }
    
    fileprivate let amountLabel = UILabel().then { $0.font = Font.textLabel }
    
    fileprivate let timePlatformLabel = UILabel().then {
        $0.font = Font.detailTextLabel
        $0.textColor = .darkGray
    }
    
    fileprivate let balanceLabel = UILabel().then {
        $0.font = Font.detailTextLabel
        $0.textColor = .darkGray
    }
    
    fileprivate lazy var verticalStackView1 = UIStackView(
        arrangedSubviews: [targetNameLabel, timePlatformLabel]
    ).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillEqually
        $0.spacing = 3
    }
    
    fileprivate lazy var verticalStackView2 = UIStackView(
        arrangedSubviews: [amountLabel, balanceLabel]
    ).then {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fillEqually
        $0.spacing = 3
    }
    
    fileprivate lazy var verticalStackView3 = UIStackView(
        arrangedSubviews: [dateLabel, UIView()]
    ).then {
        $0.axis = .vertical
        $0.alignment = .top
        $0.distribution = .fillEqually
    }
    
    fileprivate lazy var horizontalStackView = UIStackView(
        arrangedSubviews: [verticalStackView3, verticalStackView1, verticalStackView2]
    ).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.spacing = 0
    }
    
    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.horizontalStackView)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.horizontalStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.leftRightPadding)
            make.right.equalToSuperview().offset(-Metric.leftRightPadding)
            make.top.equalToSuperview().offset(Metric.topBottomPadding)
            make.bottom.equalToSuperview().offset(-Metric.topBottomPadding)
        }
    }
    
    func bind(reactor: Reactor) {
        // MARK: - output
        reactor.state.map { $0.amount }
            .subscribe(onNext: { [weak self] response in
                if response > 0 {
                    self?.amountLabel.textColor = R.color.accentColor()
                }
                self?.amountLabel.text = response.decimalWon()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.balance }
            .bind(to: self.balanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.date }
            .bind(to: self.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.name }
            .bind(to: self.targetNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.timePlatform }
            .bind(to: self.timePlatformLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
