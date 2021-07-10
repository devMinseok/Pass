//
//  AuthServiceStub.swift
//  PassTests
//
//  Created by 강민석 on 2021/06/03.
//

import RxSwift
import Stubber
@testable import Pass

final class AuthServiceStub: AuthServiceType {
    var currentToken: Token? {
        return nil
    }
    
    func login(_ email: String, _ password: String) -> Observable<Void> {
        return Stubber.invoke(authorize, args: (), default: .never())
    }
    
    func register(_ password: String, _ name: String, _ email: String, _ phone: String) -> Observable<Void> {
        <#code#>
    }
    
    func logout() {
        <#code#>
    }
}
