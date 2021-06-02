//
//  BankCheckListViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/06/02.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources

final class BankCheckListViewController: BaseViewController, View {
    
    typealias Reactor = BankListViewReactor
    
    // MARK: Constants
    fileprivate struct Reusable {
        static let bankCell = ReusableCell<BankListCell>()
    }
    
    fileprivate struct Metric {
        static let textLabelPadding = 20.f
        static let collectionViewPadding = 20.f
        static let subTextLabelTop = 10.f
    }
    
    fileprivate struct Font {
        static let textLabel = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let subTextLabel = UIFont.systemFont(ofSize: 13, weight: .light)
    }
    
    // MARK: - Properties
    fileprivate let dataSource: RxCollectionViewSectionedReloadDataSource<BankListViewSection>
    
    // MARK: - UI
    let textLabel = UILabel().then {
        $0.font = Font.textLabel
        $0.text = "잔액을 확인할\n은행을 선택해주세요"
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    let subTextLabel = UILabel().then {
        $0.font = Font.subTextLabel
        $0.text = "선택한 은행의 모든 계좌 내역을 확인할 수 있어요"
        $0.textAlignment = .left
    }
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.register(Reusable.bankCell)
    }
    
    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        self.dataSource = type(of: self).dataSourceFactory()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func dataSourceFactory() -> RxCollectionViewSectionedReloadDataSource<BankListViewSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .bankCell(reactor):
                    let cell = collectionView.dequeue(Reusable.bankCell, for: indexPath)
                    cell.reactor = reactor
                    return cell
                }
            }
        )
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = R.color.signatureColor()
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.textLabel)
        self.view.addSubview(self.subTextLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.textLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.textLabelPadding)
            make.left.equalToSuperview().offset(Metric.textLabelPadding)
            make.right.equalToSuperview().offset(-Metric.textLabelPadding)
        }
        
        self.subTextLabel.snp.makeConstraints { make in
            make.left.equalTo(self.textLabel.snp.left)
            make.top.equalTo(self.textLabel.snp.bottom).offset(Metric.subTextLabelTop)
            make.right.equalToSuperview().offset(-Metric.textLabelPadding)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.collectionViewPadding)
            make.right.equalToSuperview().offset(-Metric.collectionViewPadding)
            make.top.equalTo(self.subTextLabel.snp.bottom).offset(Metric.collectionViewPadding)
            make.bottom.equalToSuperview().offset(-Metric.collectionViewPadding)
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let sectionItem = self?.dataSource[indexPath] else { return }
                
                switch sectionItem {
                case let .bankCell(reactor):
                    self?.reactor?.steps.accept(PassStep.inputAccountNumberIsRequired(reactor.bank))
                }
            })
            .disposed(by: disposeBag)
    }
}

extension BankCheckListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width / 3) - 9
        
        return CGSize(width: cellWidth, height: 80)
    }
}
