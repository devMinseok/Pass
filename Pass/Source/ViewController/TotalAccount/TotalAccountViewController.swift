//
//  TotalAccountViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources

final class TotalAccountViewController: BaseViewController, View {
    
    typealias Reactor = TotalAccountViewReactor
    
    // MARK: Constants
    fileprivate struct Reusable {
        static let sectionHeaderView = ReusableView<HomeSectionHeaderView>()
        
        static let accountCell = ReusableCell<AccountCell>()
        static let addAccountCdll = ReusableCell<AddAccountCell>()
    }

    // MARK: - Properties
    fileprivate let dataSource: RxTableViewSectionedReloadDataSource<TotalAccountViewSection>

    // MARK: - UI
    let refreshControl = RefreshControl()
    fileprivate let tableView = UITableView(
        frame: .zero,
        style: .grouped
    ).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(Reusable.sectionHeaderView)
        $0.register(Reusable.accountCell)
        $0.register(Reusable.addAccountCdll)
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
    
    private static func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<TotalAccountViewSection> {
        return .init(
            configureCell: { dataSource, tableView, indexPath, sectionItem in
                switch sectionItem {
                case let .account(reactor):
                    let cell = tableView.dequeue(Reusable.accountCell, for: indexPath)
                    cell.reactor = reactor
                    return cell
                    
                case .addAccount:
                    let cell = tableView.dequeue(Reusable.addAccountCdll, for: indexPath)
                    return cell
                }
            }
        )
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "계좌"
        
        self.view.backgroundColor = .systemGroupedBackground
        
        self.tableView.refreshControl = refreshControl
        self.view.addSubview(self.tableView)
        self.tableView.sectionFooterHeight = 0
        
        self.setHeaderView()
    }
    
    func setHeaderView() {
        let headerView = TotalAccountViewHeader()
        
        if let accounts = self.reactor?.currentState.bankAccounts {
            let totalBalance = accounts.reduce(0) { $0 + $1.balance }
            headerView.totalBalanceLabel.text = totalBalance.decimalWon()
        }
        
        self.tableView.tableHeaderView = headerView
    }

    override func setupConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        self.rx.viewDidLoad
            .map { Reactor.Action.setInitialAccounts }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected(dataSource: self.dataSource)
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                
                switch sectionItem {
                case let .account(reactor):
                    let bankAccount = reactor.currentState.bankAccount
                    self.reactor?.steps.accept(PassStep.accountIsRequired(bankAccount))
                    
                case .addAccount:
                    self.reactor?.steps.accept(PassStep.addAccountIsRequired)
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
}

extension TotalAccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = self.dataSource[indexPath]
        
        switch sectionItem {
        case .account:
            return 70
        case .addAccount:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeue(Reusable.sectionHeaderView)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 15
    }
}
