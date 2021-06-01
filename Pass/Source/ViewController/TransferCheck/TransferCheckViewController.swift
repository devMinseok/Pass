//
//  TransferCheckViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/06/01.
//

import UIKit

import ReactorKit

final class TransferCheckViewController: BaseViewController, View {
    
    typealias Reactor = TransferCheckViewReactor
    
    // MARK: Constants
    struct Metric {
        static let bankImageViewSize = 90.f
        static let bankImageViewTop = 40.f
        
        static let sendLabelTop = 15.f
        
        static let sendButtonLeftRight = 20.f
        static let sendButtonBottom = 10.f
        static let sendButtonHeight = 55.f
        
        static let accountSelectButtonHeight = 60.f
    }
    
    struct Font {
        static let sendLabel = UIFont.systemFont(ofSize: 25, weight: .medium)
        static let accountInfoLabel = UIFont.systemFont(ofSize: 15, weight: .light)
    }

    // MARK: - Properties

    // MARK: - UI
    fileprivate let bankImageView = UIImageView().then {
        $0.layer.cornerRadius = Metric.bankImageViewSize * 0.5
        $0.layer.masksToBounds = true
    }
    
    fileprivate let sendLabel = UILabel().then {
        $0.font = Font.sendLabel
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    fileprivate let accountInfoLabel = UILabel().then {
        $0.font = Font.accountInfoLabel
        $0.textAlignment = .center
    }
    
    fileprivate let selectAccountButton = UIButton()
    
    fileprivate let sendButton = PassPlainButton().then {
        $0.setTitle("보내기", for: .normal)
    }
    
    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.bankImageView)
        self.view.addSubview(self.sendLabel)
        self.view.addSubview(self.accountInfoLabel)
        self.view.addSubview(self.sendButton)
        self.view.addSubview(self.selectAccountButton)
    }

    override func setupConstraints() {
        self.bankImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.bankImageViewTop)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Metric.bankImageViewSize)
        }
        
        self.sendLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.bankImageView.snp.bottom).offset(Metric.sendLabelTop)
        }
        
        self.accountInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.sendLabel.snp.bottom).offset(Metric.sendLabelTop)
        }
        
        self.selectAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.sendButton.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.accountSelectButtonHeight)
        }
        
        self.sendButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-Metric.sendButtonBottom)
            make.left.equalTo(Metric.sendButtonLeftRight)
            make.right.equalTo(-Metric.sendButtonLeftRight)
            make.height.equalTo(Metric.sendButtonHeight)
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        self.sendButton.rx.tap
            .map { Reactor.Action.send }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.bank.logoURL }
            .bind(to: self.bankImageView.rx.image())
            .disposed(by: disposeBag)
        
        reactor.state
            .subscribe(onNext: { state in
                self.sendLabel.text = "\(state.accountNumber) 계좌로\n\(state.amount)원을 보냅니다"
                self.accountInfoLabel.text = "\(state.bank.bankName) \(state.accountNumber)"
            })
            .disposed(by: disposeBag)
    }
}
