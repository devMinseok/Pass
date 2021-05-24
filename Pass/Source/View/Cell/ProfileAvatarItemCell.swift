//
//  ProfileItemAvatarCell.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import UIKit

import ReactorKit

final class ProfileAvatarItemCell: BaseTableViewCell, View {
    
    typealias Reactor = ProfileAvatarItemCellReactor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(avatarImageView)
    }
    
    let avatarImageView = UIImageView().then {
        $0.layer.cornerRadius = 85 * 0.5
        $0.clipsToBounds = true
    }
    
    func bind(reactor: Reactor) {
        reactor.state.map { $0.avatarURL }
            .bind(to: self.avatarImageView.rx.image())
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.avatarImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(85)
        }
    }
}
