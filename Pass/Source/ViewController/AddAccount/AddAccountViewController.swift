//
//  AddAccountViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import UIKit

import ReactorKit

final class AddAccountViewController: BaseViewController, View {
    
    typealias Reactor = AddAccountViewReactor
    
    // MARK: Constants
    struct Metric {
        
    }
    
    struct Font {
        
    }

    // MARK: - Properties

    // MARK: - UI

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

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func setupConstraints() {
        
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        
        // MARK: - output
        
    }
}
