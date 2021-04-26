//
//  SignupViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/04/06.
//

import UIKit
import ReactorKit

class SignupViewController: BaseViewController, View {
    
    typealias Reactor = SignupViewReactor
    
    let presentMainScreen: () -> Void
    
    init(
        reactor: Reactor,
        presentMainScreen: @escaping () -> Void
    ) {
        defer { self.reactor = reactor }
        self.presentMainScreen = presentMainScreen
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func setupConstraints() {
        
    }
    
    func bind(reactor: Reactor) {
        
    }
    
}
