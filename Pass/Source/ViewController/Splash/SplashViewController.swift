//
//  SplashViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/03/19.
//

import UIKit
import ReactorKit

final class SplashViewController: BaseViewController, View {
    
    typealias Reactor = SplashViewReactor
    
    // MARK: - Constants
    struct Metric {
        static let logoWidthHeight = 100.f
        static let logoCenterY = 100.f
    }
    
    // MARK: - UI
    let appLogo = UIImageView().then {
        $0.image = R.image.splashLogo()
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = R.color.signatureColor()
        self.view.addSubview(self.appLogo)
    }
    
    override func setupConstraints() {
        self.appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Metric.logoCenterY)
            make.height.width.equalTo(Metric.logoWidthHeight)
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
