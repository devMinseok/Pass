//
//  NumberButton.swift
//  Pass
//
//  Created by 강민석 on 2021/05/01.
//

import UIKit
import RxSwift

enum NumberButtonType {
    case number(Int)
    case backspace
    case clear
}

class NumberButton: UIButton {
    
    let disposeBag = DisposeBag()
    
    var type: NumberButtonType = .number(0)
    var subject = PublishSubject<NumberButtonType>()
    
    // MARK: Constants
    fileprivate struct Font {
        static let buttonTitle = UIFont.systemFont(ofSize: 35)
        static let cancelTitle = UIFont.systemFont(ofSize: 20)
    }
    
    // MARK: - Initializing
    init(_ type: NumberButtonType, _ subject: PublishSubject<NumberButtonType>) {
        super.init(frame: .zero)
        
        self.subject = subject
        self.type = type
        
        self.setupUI()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func setupUI() {
        switch type {
        case let .number(number):
            self.setTitle("\(number)", for: .normal)
            self.titleLabel?.font = Font.buttonTitle
        case .backspace:
            self.setImage(R.image.leftArrow(), for: .normal)
        case .clear:
            self.setTitle("취소", for: .normal)
            self.titleLabel?.font = Font.cancelTitle
        }
    }
    
    func bind() {
        self.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.subject.onNext(self.type)
                HapticFeedback.impactFeedback(style: .rigid)
            }).disposed(by: disposeBag)
    }
}
