//
//  StartViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/04/07.
//

import UIKit
import ReactorKit

final class StartViewController: BaseViewController {
    
    let presentMainScreen: () -> Void
    let signupViewReactor: SignupViewReactor
    
    let mainLabel = UILabel().then {
        $0.text = """
        금융의 모든 것
        패스에서 간편하게
        """
    }
    
    let subLabel = UILabel().then {
        $0.text = """
        패스는 안전합니다.
        누적 다운로드 4,000만, 누적 보안사고 0건
        """
    }
    
    let securityImage = R.image.security
    let securityLabel = UILabel().then {
        $0.text = "개인 정보 보호 모드 작동 중"
    }
    
    let startButton = UIButton().then {
        //        $0.titleLabel?.font =
        $0.setTitle("시작하기", for: .normal)
        $0.backgroundColor = R.color.accentColor()
    }
    
    init(
        presentMainScreen: @escaping () -> Void,
        signupViewReactor: SignupViewReactor
    ) {
        self.presentMainScreen = presentMainScreen
        self.signupViewReactor = signupViewReactor
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        
        self.activityIndicatorView.startAnimating()
        self.view.addSubview(self.mainLabel)
        self.view.addSubview(self.subLabel)
        self.view.addSubview(self.startButton)
    }
    
    override func setupConstraints() {
        self.mainLabel.snp.makeConstraints { (make) in
            
        }
        
        self.subLabel.snp.makeConstraints { (make) in
            
        }
        
        self.securityLabel.snp.makeConstraints { (make) in
            
        }
        
        self.startButton.snp.makeConstraints { (make) in
            
        }
    }
    
    func bind() {
        startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let viewController = SignupViewController(reactor: self.signupViewReactor,
                                                          presentMainScreen: self.presentMainScreen)
                
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
