//
//  LoginViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/04/30.
//

import UIKit

import ReactorKit

final class LoginViewController: BaseViewController, View {
    
    typealias Reactor = LoginViewReactor
    
    // MARK: Constants
    struct Metric {
        static let titleLabelTop = 90.f
        static let titleLabelLeftRight = 35.f
        
        static let textFieldLeftRight = 20.f
        static let textFieldTop = 70.f
        static let textFieldHeight = 65.f
        
        static let checkButtonLeftRight = 20.f
        static let checkButtonBottom = 10.f
        static let checkButtonHeight = 55.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.text = "이메일을 입력해주세요."
        $0.font = Font.titleLabel
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    let nextButton = PassPlainButton().then {
        $0.setTitle("확인", for: .normal)
    }
    
    let emailTextField = PassTextField().then {
        $0.textField.keyboardType = .emailAddress
        $0.titleLabel.text = "이메일 주소"
        $0.textField.placeholder = "이메일 주소"
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
        self.view.addSubview(self.nextButton)
        self.view.addSubview(self.emailTextField)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.titleLabelTop)
            make.centerX.equalToSuperview()
            make.left.equalTo(Metric.titleLabelLeftRight)
            make.right.equalTo(-Metric.titleLabelLeftRight)
        }
        
        self.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.textFieldTop)
            make.left.equalTo(self.view.snp.left).offset(Metric.textFieldLeftRight)
            make.right.equalTo(self.view.snp.right).offset(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        self.nextButton.snp.makeConstraints { make in
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
        self.emailTextField.textField.rx.text.orEmpty
            .map { Reactor.Action.setEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.nextButton.rx.tap
            .map { Reactor.Action.next }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.validationResult }
            .distinctUntilChanged()
            .bind(to: self.nextButton.rx.error)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.validationResult }
            .distinctUntilChanged()
            .bind(to: emailTextField.rx.error)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
