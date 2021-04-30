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
    
    // MARK: - UI
    lazy var appLogo = UIImageView().then {
        $0.image = R.image.splashLogo()
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.appLogo)
    }
    
    override func setupConstraints() {
        self.appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.height.width.equalTo(100)
        }
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
