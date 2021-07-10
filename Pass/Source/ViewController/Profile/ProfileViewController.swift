//
//  ProfileViewController.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources

final class ProfileViewController: BaseViewController, View {
    
    typealias Reactor = ProfileViewReactor
    
    // MARK: Constants
    fileprivate struct Reusable {
        static let avatarCell = ReusableCell<ProfileAvatarItemCell>()
        static let cell = ReusableCell<ProfileItemCell>()
    }

    // MARK: - Properties
    fileprivate let dataSource: RxTableViewSectionedReloadDataSource<ProfileViewSection>

    // MARK: - UI
    fileprivate let tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(Reusable.cell)
        $0.register(Reusable.avatarCell)
    }

    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        self.dataSource = Self.dataSourceFactory()
        super.init()
        self.title = "사용자 정보"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<ProfileViewSection> {
        return .init(
            configureCell: { dataSource, tableView, indexPath, sectionItem in
                switch sectionItem {
                case let .avatar(reactor):
                    let cell = tableView.dequeue(Reusable.avatarCell, for: indexPath)
                    cell.reactor = reactor
                    return cell
                    
                case let .name(reactor):
                    let cell = tableView.dequeue(Reusable.cell, for: indexPath)
                    cell.reactor = reactor
                    return cell
                    
                case let .phone(reactor):
                    let cell = tableView.dequeue(Reusable.cell, for: indexPath)
                    cell.reactor = reactor
                    return cell
                    
                case let .email(reactor):
                    let cell = tableView.dequeue(Reusable.cell, for: indexPath)
                    cell.reactor = reactor
                    return cell
                }
            }
        )
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.allowsSelection = false
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
        
        // MARK: - output
        reactor.state.map { $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = self.dataSource[indexPath]

        switch sectionItem {
        case .avatar:
            return 100
            
        default:
            return 50
        }
    }
}
