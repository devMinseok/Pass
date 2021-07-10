//
//  RegisterViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/04/26.
//

import UIKit

import ReactorKit

final class RegisterViewController: BaseViewController, View {
    
    typealias Reactor = RegisterViewReactor
    
    // MARK: - Properties
    struct Metric {
        static let titleLabelTop = 50.f
        static let titleLabelLeftRight = 35.f
        
        static let textFieldLeftRight = 20.f
        static let textFieldTop = 50.f
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
        $0.text = "입력한 정보를 확인해주세요."
        $0.font = Font.titleLabel
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    let phoneTextField = PassTextField().then {
        $0.textField.keyboardType = .numberPad
        $0.titleLabel.text = "휴대폰 번호"
        $0.textField.placeholder = "휴대폰 번호"
    }
    
    let emailTextField = PassTextField().then {
        $0.textField.keyboardType = .emailAddress
        $0.titleLabel.text = "이메일 주소"
        $0.textField.placeholder = "이메일 주소"
    }
    
    let nameTextField = PassTextField().then {
        $0.titleLabel.text = "이름"
        $0.textField.placeholder = "이름"
    }
    
    let nextButton = PassPlainButton().then {
        $0.setTitle("확인", for: .normal)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = R.color.signatureColor()
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.phoneTextField)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.nameTextField)
        self.view.addSubview(self.nextButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.titleLabelTop)
            make.centerX.equalToSuperview()
            make.left.equalTo(Metric.titleLabelLeftRight)
            make.right.equalTo(-Metric.titleLabelLeftRight)
        }
        
        self.phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.textFieldTop)
            make.left.equalTo(self.view.snp.left).offset(Metric.textFieldLeftRight)
            make.right.equalTo(self.view.snp.right).offset(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        self.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(self.phoneTextField.snp.bottom).offset(Metric.textFieldTop)
            make.left.equalTo(self.view.snp.left).offset(Metric.textFieldLeftRight)
            make.right.equalTo(self.view.snp.right).offset(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        self.nameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.emailTextField.snp.bottom).offset(Metric.textFieldTop)
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
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        Observable.combineLatest(
            phoneTextField.textField.rx.text.orEmpty,
            emailTextField.textField.rx.text.orEmpty,
            nameTextField.textField.rx.text.orEmpty
        )
        .map { Reactor.Action.setFields([$0, $1, $2]) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        self.nextButton.rx.tap
            .map { Reactor.Action.next }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        let phoneValidation = reactor.state.map { $0.phoneValidationResult }.distinctUntilChanged()
        let emailValidation = reactor.state.map { $0.emailValidationResult }.distinctUntilChanged()
        let nameValidation = reactor.state.map { $0.nameValidationResult }.distinctUntilChanged()
        
        phoneValidation
            .bind(to: phoneTextField.rx.error)
            .disposed(by: disposeBag)
        
        emailValidation
            .bind(to: emailTextField.rx.error)
            .disposed(by: disposeBag)
        
        nameValidation
            .bind(to: nameTextField.rx.error)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            phoneValidation.map { $0 == .ok },
            emailValidation.map { $0 == .ok },
            nameValidation.map { $0 == .ok }
        ) { $0 && $1 && $2 }
        .bind(to: nextButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
