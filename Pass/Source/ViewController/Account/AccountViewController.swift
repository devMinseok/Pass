//
//  AccountViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import UIKit

import ReactorKit
import ReusableKit

final class AccountViewController: BaseViewController, View {
    
    typealias Reactor = AccountViewReactor
    
    // MARK: Constants
    fileprivate struct Reusable {
        static let historyCell = ReusableCell<AccountHistoryCell>()
    }

    // MARK: - Properties

    // MARK: - UI
    let refreshControl = RefreshControl()
    fileprivate let tableView = UITableView(
        frame: .zero,
        style: .grouped
    ).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(Reusable.historyCell)
    }
    
    fileprivate let accountViewHeader = AccountViewHeader()

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
        
        self.title = reactor?.currentState.bankAccount.accountNickname
        
        self.view.backgroundColor = .systemGroupedBackground
        
        self.tableView.refreshControl = refreshControl
        self.view.addSubview(self.tableView)
        
        self.setHeaderView()
    }
    
    func setHeaderView() {
        let headerView = AccountViewHeader()
        headerView.reactor = reactor?.accountViewHeaderReactor
        
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
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // MARK: - output
        reactor.state.map { $0.items }
            .bind(to: tableView.rx.items) { tableView, index, element in
                guard let cell = tableView.dequeue(Reusable.historyCell) else { return UITableViewCell() }
                cell.reactor = AccountHistoryCellReactor(accountHistory: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
