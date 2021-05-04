//
//  PassTextField.swift
//  Pass
//
//  Created by 강민석 on 2021/05/01.
//

import UIKit
import RxSwift
import RxCocoa

class PassTextField: UIView {
    
    let disposeBag = DisposeBag()
    
    // MARK: Constants
    fileprivate struct Metric {
        static let textFieldTop = 10.f
        static let separatorTop = 5.f
        static let separatorHeight = 2.5.f
    }
    
    fileprivate struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let textField = UIFont.systemFont(ofSize: 22, weight: .regular)
    }
    
    // MARK: - Properties
    
    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Font.titleLabel
    }
    
    let textField = UITextField().then {
        $0.font = Font.textField
        $0.clearButtonMode = .whileEditing
    }
    
    let separator = UIView().then {
        $0.backgroundColor = .opaqueSeparator
    }

    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.textField)
        self.addSubview(self.separator)
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
        }
        
        self.textField.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.textFieldTop)
        }
        
        self.separator.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.textField.snp.bottom).offset(Metric.separatorTop)
            make.height.equalTo(Metric.separatorHeight)
        }
    }
    
    func bind() {
        self.textField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                UIView.animate(withDuration: 0.3) {
                    self?.separator.backgroundColor = text == "" ? R.color.textGray() : R.color.accentColor()
                }
            }).disposed(by: disposeBag)
    }
}

extension Reactive where Base: PassTextField {
    var error: Binder<ValidationResult?> {
        return Binder(self.base) { textField, validation in
            switch validation {
            case let .no(error)?:
                textField.titleLabel.textColor = .red
                textField.titleLabel.text = error
            default:
                textField.titleLabel.text = " "
            }
        }
    }
}
