//
//  AuthService.swift
//  Pass
//
//  Created by 강민석 on 2021/04/07.
//

import RxSwift
import KeychainAccess

protocol AuthServiceType {
    var currentToken: Token? { get }
    
    func login(email: String, password: String) -> Observable<Void>
    func register(password: String, name: String, email: String, phone: String, birth: Date) -> Observable<Void>
    func logout()
}

final class AuthService: AuthServiceType {
    
    fileprivate let network: Network<AuthAPI> // 테스트 후 Alamofire로 대체할지 결정할 예정
    
    fileprivate let keychain = Keychain(service: "com.medium.devminseok.Pass")
    private(set) var currentToken: Token?
    
    init() {
        self.network = Network<AuthAPI>(plugins: [RequestLoggingPlugin()])
        self.currentToken = self.loadToken()
    }
    
    func login(email: String, password: String) -> Observable<Void> {
        return network.requestObject(.login(email, password), type: Token.self)
            .asObservable()
            .do(onNext: { [weak self] response in
                try self?.saveToken(response)
                self?.currentToken = response
            })
            .map { _ in }
    }
    
    func register(password: String, name: String, email: String, phone: String, birth: Date) -> Observable<Void> {
        return network.requestObject(.register(password, name, email, phone, birth), type: Token.self)
            .asObservable()
            .do(onNext: { [weak self] response in
                try self?.saveToken(response)
                self?.currentToken = response
            })
            .map { _ in }
    }
    
    func logout() {
        self.currentToken = nil
        self.deleteToken()
    }
    
    fileprivate func saveToken(_ token: Token) throws {
        let jsonEncoder: JSONEncoder = JSONEncoder()
        
        let tokenData = try jsonEncoder.encode(token)
        let token = String(data: tokenData, encoding: .utf8)
        try self.keychain.set(token ?? "", key: "token")
    }
    
    fileprivate func loadToken() -> Token? {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        
        guard let tokenData = self.keychain["token"]?.data(using: .utf8),
              let token = try? jsonDecoder.decode(Token.self, from: tokenData)
        else { return nil }
        
        return token
    }
    
    fileprivate func deleteToken() {
        try? self.keychain.remove("token")
    }
}
