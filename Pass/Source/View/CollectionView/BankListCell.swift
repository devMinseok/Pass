//
//  BankListCell.swift
//  Pass
//
//  Created by 강민석 on 2021/05/25.
//

import UIKit

import ReactorKit

class BankListCell: BaseCollectionViewCell, View {
    
    typealias Reactor = BankListCellReactor
    
    // MARK: - Constants
    fileprivate struct Metric {
        static let bankLogoSize = 25.f
        static let padding = 15.f
    }
    
    fileprivate struct Font {
        static let bankNameLabel = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    // MARK: - UI
    let bankNameLabel = UILabel().then {
        $0.font = Font.bankNameLabel
    }
    
    let bankLogo = UIImageView().then {
        $0.layer.cornerRadius = Metric.bankLogoSize * 0.5
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.bankNameLabel)
        self.contentView.addSubview(self.bankLogo)
        self.contentView.backgroundColor = .systemGroupedBackground
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        reactor.state.map { $0.bankLogoURL }
            .bind(to: self.bankLogo.rx.image())
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.bankName }
            .bind(to: self.bankNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.bankLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Metric.padding)
            make.width.height.equalTo(Metric.bankLogoSize)
        }
        
        self.bankNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Metric.padding)
        }
    }
}
