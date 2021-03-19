//
//  WindowManager.swift
//  Pass
//
//  Created by 강민석 on 2021/03/19.
//

import UIKit

final class WindowManager {
    
    private var window: UIWindow
    
    init(with window: UIWindow = UIWindow()) {
        self.window = window
    }
    
    convenience init(with scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        self.init(with: window)
    }
    
    func setRootViewController(_ controller: UIViewController = SplashViewController(reactor: SplashViewReactor())) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
