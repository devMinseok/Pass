//
//  RefreshControl.swift
//  Pass
//
//  Created by 강민석 on 2021/05/11.
//

import UIKit

final class RefreshControl: UIRefreshControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = R.color.signatureColor()
    }
    
    override convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
