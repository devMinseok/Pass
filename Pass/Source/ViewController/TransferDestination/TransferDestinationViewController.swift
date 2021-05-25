//
//  TransferDestinationViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import UIKit

import ReactorKit
import ReusableKit

final class TransferDestinationViewController: BaseViewController, View {
    
    typealias Reactor = TransferDestinationViewReactor
    
    // MARK: Constants
    struct Metric {
        static let textFieldLeftRight = 20.f
        static let textFieldTop = 70.f
        static let textFieldHeight = 65.f
    }

    // MARK: - Properties

    // MARK: - UI
    let doneButton = KeyboardTopButton()
    
    fileprivate let bankSelectField = PassTextField().then {
        $0.textField.placeholder = "은행 선택"
    }
    
    fileprivate lazy var accountNumberField = PassTextField().then {
        $0.textField.placeholder = "계좌번호 입력"
        $0.textField.keyboardType = .numberPad
        $0.textField.inputAccessoryView = doneButton
    }

    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        super.init()
        self.title = "누구에게 송금할까요?"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.bankSelectField)
        self.view.addSubview(self.accountNumberField)
    }

    override func setupConstraints() {
        self.bankSelectField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            make.left.equalTo(Metric.textFieldLeftRight)
            make.right.equalTo(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        self.accountNumberField.snp.makeConstraints { make in
            make.top.equalTo(self.bankSelectField.snp.bottom).offset(20)
            make.left.equalTo(Metric.textFieldLeftRight)
            make.right.equalTo(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        let textFieldTap = self.bankSelectField.textField.rx.tapGesture().when(.recognized).share()
        
        textFieldTap
            .map { _ in Reactor.Action.showBankList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        textFieldTap
//            .subscribe(onNext: { [weak self] _ in
//                self?.bankSelectField.textField.endEditing(true)
//            })
//            .disposed(by: disposeBag)
        
        self.doneButton.rx.tap
            .map { Reactor.Action.next }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.accountNumberValidation }
            .distinctUntilChanged()
            .bind(to: self.accountNumberField.rx.error)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.accountNumberValidation }
            .distinctUntilChanged()
            .bind(to: self.doneButton.rx.error)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.bank }
            .subscribe(onNext: { [weak self] bank in
                self?.bankSelectField.textField.text = bank?.bankName
            })
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
