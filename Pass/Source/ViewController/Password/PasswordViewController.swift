//
//  PasswordViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/01.
//

import UIKit
import RxCocoa
import ReactorKit
import RxFlow

let inputPassword = PublishSubject<String>()

final class PasswordViewController: BaseViewController, View {
    
    typealias Reactor = PasswordViewReactor
    
    // MARK: Constants
    struct Metric {
        static let descriptionLabelTop = 180.f
        static let passwordFieldTop = 10.f
        static let passwordFieldWidth = 150.f
        static let passwordFieldHeight = 50.f
        static let passwordPadHeight = 300.f
    }
    
    struct Font {
        static let descriptionLabel = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    
    // MARK: - UI
    let descriptionLabel = UILabel().then {
        $0.font = Font.descriptionLabel
        $0.text = "비밀번호를 입력해주세요"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    let passwordField = SecureTextEntry()
    
    let passwordPad = PassNumberPad(type: .random)
    
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
        
        self.view.backgroundColor = R.color.passwordBackground()
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.passwordPad)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
                .offset(Metric.descriptionLabelTop)
        }
        
        self.passwordField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.passwordFieldWidth)
            make.height.equalTo(Metric.passwordFieldHeight)
            make.top.equalTo(self.descriptionLabel.snp.bottom)
                .offset(Metric.passwordFieldTop)
        }
        
        self.passwordPad.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Metric.passwordPadHeight)
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        self.passwordPad.currentState
            .bind(to: self.passwordField.subject)
            .disposed(by: disposeBag)
        
        self.passwordField.currentText
            .map { Reactor.Action.callBack($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
    }
}
