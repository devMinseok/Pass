//
//  HomeViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources
import RxGesture

final class HomeViewController: BaseViewController, ReactorKit.View {
    
    typealias Reactor = HomeViewReactor
    
    // MARK: Constants
    fileprivate struct Reusable {
        static let totalAccountCell = ReusableCell<TotalAccountCell>()
        static let accountCell = ReusableCell<AccountCell>()
        static let addAccountCdll = ReusableCell<AddAccountCell>()
    }
    
    // MARK: - Properties
    fileprivate let dataSource: RxTableViewSectionedReloadDataSource<HomeViewSection>
    
    // MARK: - UI
    let refreshControl = UIRefreshControl()
    fileprivate let tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(Reusable.totalAccountCell)
        $0.register(Reusable.accountCell)
        $0.register(Reusable.addAccountCdll)
    }
    
    fileprivate let profileHeaderView = ProfileHeaderView()
    
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
    
    private static func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<HomeViewSection> {
        return .init(
            configureCell: { dataSource, tableView, indexPath, sectionItem in
                switch sectionItem {
                case let .totalAccount(reactor):
                    let cell = tableView.dequeue(Reusable.totalAccountCell, for: indexPath)
                    cell.reactor = reactor
                    return cell
                    
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
        
        self.refreshControl.backgroundColor = R.color.signatureColor()
        self.view.backgroundColor = .systemGroupedBackground
        self.tableView.refreshControl = refreshControl
        self.view.addSubview(self.tableView)
        
        self.profileHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 70)
        self.tableView.tableHeaderView = profileHeaderView
        
        profileHeaderView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.steps.accept(PassStep.profileIsRequried)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > -90 {
//            // 밑으로 내릴때
//        } else {
//            // 기본
//        }
//    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        self.profileHeaderView.reactor = reactor.profileHeaderViewReactor
        
        // MARK: - input
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected(dataSource: self.dataSource)
            .subscribe(onNext: { [weak self] sectoinItem in
                guard let self = self else { return }
                
                switch sectoinItem {
                case let .totalAccount(reactor):
                    let bankAccounts = reactor.currentState.bankAccounts
                    self.reactor?.steps.accept(PassStep.totalAccountsIsRequired(bankAccounts))
                    
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

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = self.dataSource[indexPath]
        
        switch sectionItem {
        case .totalAccount:
            return 60
        case .account:
            return 70
        case .addAccount:
            return 80
        }
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let view = UIView()
    //        view.backgroundColor = UIColor.red
    //
    //        return view
    //    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
