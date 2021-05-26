//
//  AnimationLabel.swift
//  Pass
//
//  Created by 강민석 on 2021/05/25.
//

import UIKit
import RxSwift
import RxCocoa

class AnimationLabel: UIView {
    
    // MARK: - Constants
    struct Font {
        static let warningMessage = UIFont.systemFont(ofSize: 15, weight: .medium)
        static let currentNumberLabel = UIFont.systemFont(ofSize: 45, weight: .regular)
        static let changeMaxAmountButton = UIFont.systemFont(ofSize: 14)
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let MAX = 500000
    let currentState = BehaviorSubject<Bool>(value: false)
    let subject = PublishSubject<NumberButtonType>()
    var currentNumber = ""
    
    // MARK: - UI
    private lazy var currentNumberStackView = UIStackView(
        arrangedSubviews: [currentNumberLabel, wonLabel]
    ).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    
    private let warningMessage = UILabel().then {
        $0.text = "최대 50만원까지 입력할 수 있습니다"
        $0.textColor = R.color.textAccent()
        $0.font = Font.warningMessage
        $0.isHidden = true
    }
    
    let currentNumberLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = R.color.textAccent()
        $0.font = Font.currentNumberLabel
    }
    
    let wonLabel = UILabel().then {
        $0.text = "원"
        $0.textColor = R.color.textAccent()
        $0.font = Font.currentNumberLabel
    }
    
    let changeMaxAmountButton = UIButton().then {
        $0.setTitle("500,000원으로 변경", for: .normal)
        $0.titleLabel?.font = Font.changeMaxAmountButton
        $0.setTitleColor(R.color.textAccent(), for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .systemGroupedBackground
        $0.isHidden = true
    }
    
    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.currentNumberStackView)
        self.addSubview(self.warningMessage)
        self.addSubview(self.changeMaxAmountButton)
        
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.currentNumberStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().dividedBy(1.75)
        }
        
        self.warningMessage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.currentNumberStackView.snp.bottom).offset(10)
        }
        
        self.changeMaxAmountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(150)
            make.top.equalTo(self.warningMessage.snp.bottom).offset(5)
        }
    }
    
    private func commaForNumber(_ number: String) -> String {
        var result = NSNumber()
        guard let value = Int(number) else { return "Error" }
        result = value as NSNumber

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        guard let resultValue = formatter.string(from: result) else { return "Error" }
        return resultValue
    }
    
    func bind() {
        self.subject
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                
                switch response {
                case let .number(number):
                    if Int(self.currentNumber) ?? 0 < self.MAX {
                        if self.currentNumber == "" && number == 0 {
                            self.currentNumber = ""
                        } else {
                            self.currentNumber += String(number)
                        }
                    }
                    
                case .backspace:
                    if self.currentNumber != "" {
                        self.currentNumber.removeLast()
                    }
                    
                case .clear:
                    self.currentNumber = ""
                }
                
                self.animateNumber(number: self.currentNumber)
            })
            .disposed(by: disposeBag)
        
        self.changeMaxAmountButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.currentNumber = String(self.MAX)
                self.animateNumber(number: self.currentNumber)
            })
            .disposed(by: disposeBag)
    }
    
    func animateNumber(number: String) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
            
            if number == "" {
                self.currentNumberLabel.text = "0"
                self.currentState.onNext(false)
                
                self.warningMessage.isHidden = true
                self.changeMaxAmountButton.isHidden = true
            } else {
                if Int(number)! > self.MAX {
                    self.currentNumberLabel.text = self.commaForNumber(number)
                    self.currentState.onNext(false)
                    
                    self.warningMessage.isHidden = false
                    self.changeMaxAmountButton.isHidden = false
                    self.currentNumberLabel.shake()
                    self.wonLabel.shake()
                } else {
                    self.currentNumberLabel.text = self.commaForNumber(number)
                    self.currentState.onNext(true)
                    
                    self.warningMessage.isHidden = true
                    self.changeMaxAmountButton.isHidden = true
                }
            }
        }
    }
}
