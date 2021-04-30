//
//  BaseViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/03/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

class BaseViewController: UIViewController, Stepper {
    
    // MARK: - Properties
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    let steps = PublishRelay<Step>()
    
    // MARK: - Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Rx
    var disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    deinit {
        self.activityIndicatorView.stopAnimating()
    }
    
    // MARK: - Layout Constraints
    private(set) var didSetupConstraints = false
    
    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
        
        self.view.addSubview(self.activityIndicatorView)
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func setupConstraints() {
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
