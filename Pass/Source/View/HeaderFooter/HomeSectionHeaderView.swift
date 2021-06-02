//
//  HomeSectionHeaderView.swift
//  Pass
//
//  Created by 강민석 on 2021/05/14.
//

import UIKit

class HomeSectionHeaderView: UITableViewHeaderFooterView {
    fileprivate let separator = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = R.color.signatureColor()
        self.addSubview(self.separator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.separator.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
