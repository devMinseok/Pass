//
//  ValidationResult.swift
//  Pass
//
//  Created by 강민석 on 2021/05/04.
//

import Foundation

enum ValidationResult: Equatable {
    case ok
    case no(_ msg: String)
}

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var validEmail: ValidationResult {
        return self.isEmail ? ValidationResult.ok : ValidationResult.no("유효하지 않은 이메일")
    }
    
    var validPhone: ValidationResult {
        return self.isPhone ? ValidationResult.ok : ValidationResult.no("유효하지 않은 전화전호")
    }
    
    var validName: ValidationResult {
        return self.isName ? ValidationResult.ok : ValidationResult.no("유효하지 않은 이름")
    }
    
    var validAccountNumber: ValidationResult {
        return self.isAccountNumber ? ValidationResult.ok : ValidationResult.no("유효하지 않은 계좌번호")
    }
    
    var isEmail: Bool {
        let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX).evaluate(with: self)
    }
    
    var isPhone: Bool {
        let PHONE_REGEX = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX).evaluate(with: self)
    }
    
    var isName: Bool {
        let NAME_REGEX = "[가-힣A-Za-z0-9]{2,7}"
        return NSPredicate(format: "SELF MATCHES %@", NAME_REGEX).evaluate(with: self)
    }
    
    var isAccountNumber: Bool {
        let ACCOUNT_NUMBER_REGEX = "^[0-9]{7,}$"
        return NSPredicate(format: "SELF MATCHES %@", ACCOUNT_NUMBER_REGEX).evaluate(with: self)
    }
}
