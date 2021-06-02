//
//  UIButton+Rx.swift
//  Pass
//
//  Created by 강민석 on 2021/05/04.
//

import RxSwift
import RxCocoa
extension Reactive where Base: UIButton {
    var error: Binder<ValidationResult?> {
        return Binder(self.base) { button, validation in
            switch validation {
            case .no:
                button.isEnabled = false
            default:
                button.isEnabled = true
            }
        }
    }
}
