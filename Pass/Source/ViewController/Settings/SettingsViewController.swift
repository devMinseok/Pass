//
//  SettingsViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/04/26.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources

final class SettingsViewController: BaseViewController, View {
    
    typealias Reactor = SettingsViewReactor
    
    fileprivate struct Reusable {
        static let cell = ReusableCell<SettingItemCell>()
    }
    
    // MARK: - Properties
    fileprivate let dataSource: RxTableViewSectionedReloadDataSource<SettingsViewSection>
    
    // MARK: - UI
    fileprivate let tableView = UITableView(
        frame: .zero,
        style: .grouped
    ).then {
        $0.register(Reusable.cell)
        $0.separatorStyle = .none
    }
    
    private static func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<SettingsViewSection> {
        return .init(
            configureCell: { dataSource, tableView, indexPath, sectionItem in
                let cell = tableView.dequeue(Reusable.cell, for: indexPath)
                switch sectionItem {
                case let .myInfo(reactor):
                    cell.reactor = reactor
                    
                case let .github(reactor):
                    cell.reactor = reactor
                    
                case let .version(reactor):
                    cell.reactor = reactor
                    
                case let .logout(reactor):
                    cell.reactor = reactor
                }
                return cell
            }
        )
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
    }
    
    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        self.dataSource = Self.dataSourceFactory()
        super.init()
        self.title = "설정"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - output
        reactor.state.map { $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected(dataSource: self.dataSource)
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                switch sectionItem {
                case .myInfo:
                    reactor.action.onNext(.myInfo)
                    
                case .github:
                    reactor.action.onNext(.github)
                    
                case .version:
                    reactor.action.onNext(.version)
                    
                case .logout:
                    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    let logoutAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
                        reactor.action.onNext(.logout)
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    [logoutAction, cancelAction].forEach(actionSheet.addAction)
                    self.present(actionSheet, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: self.disposeBag)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
