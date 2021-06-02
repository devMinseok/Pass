//
//  AccountViewHeader.swift
//  Pass
//
//  Created by 강민석 on 2021/05/18.
//

import UIKit

import ReactorKit

class AccountViewHeader: UIView, View {
    var disposeBag = DisposeBag()
    
    typealias Reactor = AccountViewHeaderReactor
    
    // MARK: - Constants
    struct Metric {
        static let balanceLabelLeft = 24.f
        static let balanceLabelBottom = 25.f
        static let titleLabelBottom = 4.f
        
        static let transferButtonRight = 24.f
        static let transferButtonWidth = 62.f
        static let transferButtonHeight = 37.f
        static let transferButtonCornerRadius = 7.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 13, weight: .thin)
        static let balanceLabel = UIFont.systemFont(ofSize: 28, weight: .semibold)
        static let transferButton = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }

    // MARK: - UI
    fileprivate let titleLabel = UILabel().then {
        $0.font = Font.titleLabel
    }
    
    fileprivate let balanceLabel = UILabel().then {
        $0.font = Font.balanceLabel
    }
    
    fileprivate let transferButton = PassPlainButton().then {
        $0.setTitle("송금", for: .normal)
        $0.layer.cornerRadius = Metric.transferButtonCornerRadius
        $0.titleLabel?.font = Font.transferButton
    }
    
    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: .zero, height: 150))

        self.backgroundColor = R.color.signatureColor()
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.balanceLabel)
        self.addSubview(self.transferButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.balanceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.balanceLabelLeft)
            make.bottom.equalToSuperview().offset(-Metric.balanceLabelBottom)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.balanceLabel.snp.left)
            make.bottom.equalTo(self.balanceLabel.snp.top).offset(-Metric.titleLabelBottom)
        }
        
        self.transferButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.transferButtonRight)
            make.bottom.equalTo(self.balanceLabel.snp.bottom)
            make.width.equalTo(Metric.transferButtonWidth)
            make.height.equalTo(Metric.transferButtonHeight)
        }
    }
    
    func bind(reactor: Reactor) {
        // MARK: - input
        self.transferButton.rx.tap
            .map { Reactor.Action.transfer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.accountNumber }
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.balance }
            .bind(to: self.balanceLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
