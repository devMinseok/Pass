//
//  SplashViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/03/19.
//

import UIKit
import ReactorKit

class SplashViewController: BaseViewController, View {
    
    // MARK: - Properties
    typealias Reactor = SplashViewReactor
    let presentStartScreen: () -> Void
    let presentMainScreen: () -> Void
    
    // MARK: - UI
    lazy var appLogo = UIImageView().then {
        $0.image = R.image.splashLogo()
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(appLogo)
    }
    
    override func setupConstraints() {
        super.setupConstraints() // default indicator 설정
        appLogo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.height.width.equalTo(100)
        }
    }
    
    // MARK: - Initializing
    init(
        reactor: Reactor,
        presentStartScreen: @escaping () -> Void,
        presentMainScreen: @escaping () -> Void
    ) {
        defer { self.reactor = reactor }
        self.presentStartScreen = presentStartScreen
        self.presentMainScreen = presentMainScreen
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.checkIfAuthenticated }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isAuthenticated }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isAuthenticated in
                if isAuthenticated {
                    self?.presentMainScreen()
                } else {
                    self?.presentStartScreen()
                }
            })
            .disposed(by: disposeBag)
    }
}
