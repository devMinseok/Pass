//
//  AppServices.swift
//  Pass
//
//  Created by 강민석 on 2021/04/06.
//

import Kingfisher
import RxViewController
import RxOptional
import SnapKit
import Then

struct AppServices {
    let authService: AuthServiceType
    let userService: UserServiceType
    let accountService: AccountServiceType
    
    init() {
        self.authService = AuthService()
        
        let network = Network<PassAPI>(
            plugins: [
                RequestLoggingPlugin(),
                AuthPlugin(authService: authService)
            ]
        )
        
        self.userService = UserService(network: network)
        self.accountService = AccountService(network: network)
    }
}
