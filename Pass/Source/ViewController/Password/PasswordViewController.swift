//
//  PasswordViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/04/28.
//

import UIKit

import ReactorKit

final class PasswordViewController: BaseViewController, View {
    
    typealias Reactor = PasswordViewReactor
    
    // MARK: - Properties
    
    // MARK: - UI
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        
    }
    
}
