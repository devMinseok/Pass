//
//  InputAccountNumberViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/06/02.
//

import UIKit

import ReactorKit

final class InputAccountNumberViewController: BaseViewController, View {
    
    typealias Reactor = InputAccountNumberViewReactor
    
    // MARK: Constants
    struct Metric {
        static let titleLabelTop = 90.f
        static let titleLabelLeftRight = 35.f
        
        static let textFieldLeftRight = 20.f
        static let textFieldTop = 70.f
        static let textFieldHeight = 65.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.font = Font.titleLabel
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    let doneButton = KeyboardTopButton()
    
    lazy var accountNumberTextField = PassTextField().then {
        $0.textField.keyboardType = .numberPad
        $0.textField.placeholder = "계좌 번호"
        $0.textField.inputAccessoryView = doneButton
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
        
        self.view.backgroundColor = R.color.signatureColor()
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.accountNumberTextField)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.titleLabelTop)
            make.centerX.equalToSuperview()
            make.left.equalTo(Metric.titleLabelLeftRight)
            make.right.equalTo(-Metric.titleLabelLeftRight)
        }
        
        self.accountNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.textFieldTop)
            make.left.equalTo(self.view.snp.left).offset(Metric.textFieldLeftRight)
            make.right.equalTo(self.view.snp.right).offset(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        
        // MARK: - input
        self.accountNumberTextField.textField.rx.text.orEmpty
            .map(Reactor.Action.setAccountNumber)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.doneButton.rx.tap
            .map { Reactor.Action.next }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.accountNumberValidation }
            .distinctUntilChanged()
            .bind(to: self.doneButton.rx.error)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.accountNumberValidation }
            .distinctUntilChanged()
            .bind(to: accountNumberTextField.rx.error)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.bank }
            .subscribe(onNext: { [weak self] bank in
                self?.titleLabel.text = "\(bank.bankName) 계좌번호를\n입력해주세요"
            })
            .disposed(by: disposeBag)
    }
}
