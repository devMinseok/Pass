//
//  UITableView+Rx.swift
//  Pass
//
//  Created by 강민석 on 2021/05/13.
//

import RxSwift
import RxDataSources
import RxCocoa

extension Reactive where Base: UITableView {
    func itemSelected<S>(dataSource: TableViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
}
