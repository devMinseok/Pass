//
//  IntroViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/04/28.
//

import UIKit

import ReactorKit

final class IntroViewController: BaseViewController, View {
    
    typealias Reactor = IntroViewReactor
    
    // MARK: Constants
    struct Metric {
        static let titleLabelTop = 100.f
        static let titleLabelLeftRight = 50.f
        
        static let subTitleLabelTop = 25.f
        
        static let loginButtonBottom = 20.f
        
        static let signupButtonLeftRight = 20.f
        static let signupButtonBottom = 10.f
        static let signupButtonHeight = 55.f
        static let signupButtonCornerRadius = 12.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let subTitleLabel = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        static let loginButtonTitle = UIFont.systemFont(ofSize: 15, weight: .bold)
        static let signupButtonTitle = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    // MARK: - Properties
    
    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.text = "금융의 모든 것\n패스에서 간편하게"
        $0.font = Font.titleLabel
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    let subTitleLabel = UILabel().then {
        $0.textColor = R.color.textGray()
        $0.font = Font.subTitleLabel
        $0.numberOfLines = 0
        $0.textAlignment = .left
        
        let text = "패스는 안전합니다\n누적 다운로드 4,000만, 누적 보안사고 0건"
        $0.attributedText = text.attributing(["4,000만", "0건"], color: R.color.accentColor())
    }
    
    let loginButton = UIButton(type: .system).then {
        $0.setTitle("이미 계정이 있으신가요?", for: .normal)
        $0.titleLabel?.font = Font.loginButtonTitle
        $0.setTitleColor(R.color.textGray(), for: .normal)
    }
    
    let signupButton = CustomButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.titleLabel?.font = Font.signupButtonTitle
        $0.layer.cornerRadius = Metric.signupButtonCornerRadius
        $0.backgroundColor = R.color.accentColor()
//        $0.highlightedBackgroundColor = R.color.textGray()
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
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.subTitleLabel)
        self.view.addSubview(self.signupButton)
        self.view.addSubview(self.loginButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.titleLabelTop)
            make.left.equalTo(Metric.titleLabelLeftRight)
            make.right.equalTo(-Metric.titleLabelLeftRight)
        }
        
        self.subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.subTitleLabelTop)
            make.left.equalTo(self.titleLabel.snp.left)
            make.right.equalTo(self.titleLabel.snp.right)
        }
        
        self.signupButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(Metric.signupButtonLeftRight)
            make.right.equalTo(-Metric.signupButtonLeftRight)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-Metric.signupButtonBottom)
            make.height.equalTo(Metric.signupButtonHeight)
        }
        
        self.loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.signupButton.snp.top).offset(-Metric.loginButtonBottom)
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        
        self.signupButton.rx.tap
            .subscribe(onNext: {
                print("signup")
            }).disposed(by: disposeBag)
        
        self.loginButton.rx.tap
            .subscribe(onNext: {
                print("login")
            }).disposed(by: disposeBag)

    }
}
