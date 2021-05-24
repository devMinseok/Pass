//
//  TotalAccountViewHeader.swift
//  Pass
//
//  Created by 강민석 on 2021/05/17.
//

import UIKit

class TotalAccountViewHeader: UIView {
    
    // MARK: - Constants
    struct Metric {
        static let totalBalanceLabelLeft = 24.f
        static let totalBalanceLabelBottom = 25.f
        static let titleLabelBottom = 4.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 13, weight: .thin)
        static let totalBalanceLabel = UIFont.systemFont(ofSize: 28, weight: .semibold)
    }

    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.font = Font.titleLabel
        $0.text = "총 계좌 잔액"
    }
    
    let totalBalanceLabel = UILabel().then {
        $0.font = Font.totalBalanceLabel
    }
    
    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: .zero, height: 150))

        self.backgroundColor = R.color.signatureColor()
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.totalBalanceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.totalBalanceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.totalBalanceLabelLeft)
            make.bottom.equalToSuperview().offset(-Metric.totalBalanceLabelBottom)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.totalBalanceLabel.snp.left)
            make.bottom.equalTo(self.totalBalanceLabel.snp.top).offset(-Metric.titleLabelBottom)
        }
    }
}
