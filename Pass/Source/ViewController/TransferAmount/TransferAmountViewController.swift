//
//  TransferAmountViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/25.
//

import UIKit

import ReactorKit

final class TransferAmountViewController: BaseViewController, View {
    
    typealias Reactor = TransferAmountViewReactor
    
    // MARK: Constants
    struct Metric {
        static let numberPadHeight = 300.f
        static let numberPadBottom = 15.f
        
        static let checkButtonLeftRight = 20.f
        static let checkButtonBottom = 10.f
        static let checkButtonHeight = 55.f
        
        static let amountLabelHeight = 150.f
        static let accountInfoLabelTop = 100.f
    }
    
    struct Font {
        static let accountInfoLabel = UIFont.systemFont(ofSize: 15, weight: .bold)
        static let accountInfoLabelAttribute = UIFont.systemFont(ofSize: 15, weight: .light)
    }

    // MARK: - Properties

    // MARK: - UI
    let accountInfoLabel = UILabel().then {
        $0.font = Font.accountInfoLabel
        $0.textAlignment = .center
    }
    
    let amountLabel = AnimationLabel()
    let numberPad = PassNumberPad(type: .normal)
    
    let sendButton = PassPlainButton().then {
        $0.setTitle("보내기", for: .normal)
    }

    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        super.init()
        self.title = "송금"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = R.color.signatureColor()
        
        self.view.addSubview(self.accountInfoLabel)
        self.view.addSubview(self.amountLabel)
        self.view.addSubview(self.numberPad)
        self.view.addSubview(self.sendButton)
    }

    override func setupConstraints() {
        self.accountInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.accountInfoLabelTop)
            make.centerX.equalToSuperview()
        }
        
        self.amountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.accountInfoLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.amountLabelHeight)
        }
        
        self.numberPad.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(Metric.numberPadHeight)
            make.bottom.equalTo(self.sendButton.snp.top).offset(-Metric.numberPadBottom)
        }
        
        self.sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-Metric.checkButtonBottom)
            make.centerX.equalToSuperview()
            make.left.equalTo(Metric.checkButtonLeftRight)
            make.right.equalTo(-Metric.checkButtonLeftRight)
            make.height.equalTo(Metric.checkButtonHeight)
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        self.sendButton.rx.tap
            .map { Reactor.Action.next(self.amountLabel.currentNumber) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state
            .subscribe(onNext: { [weak self] response in
                let text = "\(response.bank.bankName) \(response.accountNumber) 계좌로"
                self?.accountInfoLabel.attributedText = text.attributing(["계좌로"], color: UIColor.lightGray, font: Font.accountInfoLabelAttribute)
            })
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.numberPad.currentState
            .bind(to: self.amountLabel.subject)
            .disposed(by: disposeBag)
        
        self.amountLabel.currentState
            .bind(to: self.sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
