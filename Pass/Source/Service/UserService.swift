//
//  UserService.swift
//  Pass
//
//  Created by 강민석 on 2021/04/05.
//

import RxSwift

protocol UserServiceType {
    var currentUser: Observable<User?> { get }
    
    func fetchUser() -> Single<Void>
}

final class UserService: UserServiceType {
    fileprivate let network: Network<PassAPI>
    
    init(network: Network<PassAPI>) {
        self.network = network
    }
    
    fileprivate let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    lazy var currentUser: Observable<User?> = self.userSubject.asObservable()
        .startWith(nil)
        .share(replay: 1, scope: .forever) // subscribe가 끊어져도 scope를 지속시킴
    
    func fetchUser() -> Single<Void> {
        return network.requestObject(.getMyInfo, type: User.self)
            .do(onSuccess: { [weak self] user in
                self?.userSubject.onNext(user)
            })
            .map { _ in }
    }
}
