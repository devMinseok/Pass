//
//  ProfileHeaderView.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import UIKit

import ReactorKit

final class ProfileHeaderView: UIView, View {
    
    typealias Reactor = ProfileHeaderViewReactor
    
    // MARK: Constants
    struct Metric {
        static let profileViewSize = 47.f
        static let profileViewLeft = 23.f
        
        static let stackViewLeft = 11.f
        static let stackViewSpacing = 3.f
        
        static let transferButtonRight = 23.f
        static let transferButtonWidth = 62.f
        static let transferButtonHeight = 37.f
        static let transferButtonCornerRadius = 7.f
    }
    
    struct Font {
        static let nameLabel = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let subTitleLabel = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let transferButton = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI
    fileprivate let profileView = UIImageView().then {
        $0.layer.cornerRadius = Metric.profileViewSize * 0.5
        $0.clipsToBounds = true
    }
    
    fileprivate let nameLabel = UILabel().then {
        $0.font = Font.nameLabel
    }
    
    fileprivate let subTitleLabel = UILabel().then {
        $0.text = "내 정보 보기"
        $0.font = Font.subTitleLabel
        $0.textColor = .gray
    }
    
    fileprivate let transferButton = PassPlainButton().then {
        $0.setTitle("송금", for: .normal)
        $0.layer.cornerRadius = Metric.transferButtonCornerRadius
        $0.titleLabel?.font = Font.transferButton
    }
    
    fileprivate lazy var stackView = UIStackView(
        arrangedSubviews: [nameLabel, subTitleLabel]
    ).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillEqually
        $0.spacing = Metric.stackViewSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: .zero, height: 70))
        
        self.backgroundColor = R.color.signatureColor()
        
        self.addSubview(self.profileView)
        self.addSubview(self.stackView)
        self.addSubview(self.transferButton)
        
        self.profileView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.profileViewLeft)
            make.width.equalTo(Metric.profileViewSize)
            make.height.equalTo(Metric.profileViewSize)
        }
        
        self.transferButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Metric.transferButtonRight)
            make.width.equalTo(Metric.transferButtonWidth)
            make.height.equalTo(Metric.transferButtonHeight)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.profileView.snp.right).offset(Metric.stackViewLeft)
            make.right.equalTo(self.transferButton.snp.left)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualToSuperview()
        }

        self.subTitleLabel.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        Observable.just(Reactor.Action.refresh)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.transferButton.rx.tap
            .map { Reactor.Action.transfer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profileImage }
            .subscribe(onNext: { [weak self] url in
                self?.profileView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
    }
}
