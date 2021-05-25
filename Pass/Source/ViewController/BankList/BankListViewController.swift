//
//  BankListViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources

let selectedBank = PublishSubject<Bank>()

final class BankListViewController: BaseViewController, View {
    
    typealias Reactor = BankListViewReactor
    
    // MARK: Constants
    fileprivate struct Reusable {
        static let bankCell = ReusableCell<BankListCell>()
    }
    
    fileprivate struct Metric {
        static let textLabelPadding = 20.f
        static let collectionViewPadding = 20.f
    }
    
    fileprivate struct Font {
        static let textLabel = UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    
    // MARK: - Properties
    fileprivate let dataSource: RxCollectionViewSectionedReloadDataSource<BankListViewSection>
    
    // MARK: - UI
    let textLabel = UILabel().then {
        $0.font = Font.textLabel
        $0.text = "은행을 선택하세요"
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
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.textLabel)
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
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let sectionItem = self?.dataSource[indexPath] else { return }
                
                switch sectionItem {
                case let .bankCell(reactor):
                    selectedBank.onNext(reactor.bank)
                    self?.reactor?.steps.accept(PassStep.dismiss)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension BankListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width / 3) - 9
        
        return CGSize(width: cellWidth, height: 80)
    }
}
