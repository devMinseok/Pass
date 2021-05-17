//
//  TabBarViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/04/27.
//

import UIKit
import RxSwift

class TabBarViewController: UITabBarController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tabBar.barTintColor = R.color.signatureColor()
        self.tabBar.tintColor = R.color.textAccent()
                
        self.tabBar.layer.masksToBounds = true
        self.tabBar.barStyle = .default
        self.tabBar.layer.cornerRadius = 23
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.tabBar.layer.borderWidth = 0.3
        self.tabBar.layer.borderColor = R.color.textGray()?.cgColor
        
        self.tabBar.frame.size.height = 95
        self.tabBar.frame.origin.y = self.view.frame.height - 95
    }
    
    func bind() {
        self.rx.didSelect
            .scan((nil, nil)) { state, viewController in
                return (state.1, viewController)
            }
            // if select the view controller first time or select the same view controller again
            .filter { state in state.0 == nil || state.0 === state.1 }
            .map { state in state.1 }
            .filterNil()
            .subscribe(onNext: { [weak self] viewController in
                self?.scrollToTop(viewController) // scroll to top
            })
            .disposed(by: self.disposeBag)
    }
    
    func scrollToTop(_ viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            let topViewController = navigationController.topViewController
            let firstViewController = navigationController.viewControllers.first
            if let viewController = topViewController, topViewController === firstViewController {
                self.scrollToTop(viewController)
            }
            return
        }
        guard let scrollView = viewController.view.subviews[1] as? UIScrollView else { return }
        
        scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
}
