//
//  BankListViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import UIKit

import ReactorKit

let selectedBank = PublishSubject<Bank>()

final class BankListViewController: BaseViewController, View {
    
    typealias Reactor = BankListViewReactor
    
    // MARK: Constants
    struct Metric {
        static let textLabelPadding = 20.f
        static let collectionViewPadding = 20.f
    }
    
    struct Font {
        static let textLabel = UIFont.systemFont(ofSize: 20, weight: .medium)
    }

    // MARK: - Properties

    // MARK: - UI
    let textLabel = UILabel().then {
        $0.font = Font.textLabel
        $0.text = "은행을 선택하세요"
        $0.textAlignment = .left
    }
    
    let collectionView = UICollectionView()

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
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(textLabel)
    }

    override func setupConstraints() {
        self.textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.textLabelPadding)
            make.left.equalToSuperview().offset(Metric.textLabelPadding)
            make.right.equalToSuperview().offset(-Metric.textLabelPadding)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.collectionViewPadding)
            make.right.equalToSuperview().offset(-Metric.collectionViewPadding)
            make.top.equalTo(self.textLabel.snp.bottom).offset(Metric.collectionViewPadding)
            make.bottom.equalToSuperview().offset(-Metric.collectionViewPadding)
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        
        // MARK: - output
//        reactor.action.map
    }
}
