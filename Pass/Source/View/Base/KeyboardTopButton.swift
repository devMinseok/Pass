//
//  KeyboardTopButton.swift
//  Pass
//
//  Created by 강민석 on 2021/05/24.
//

import UIKit
import RxSwift

final class KeyboardTopButton: PassPlainButton {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: .zero, height: 50))
        
        self.layer.cornerRadius = 0
        self.setTitle("확인", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
