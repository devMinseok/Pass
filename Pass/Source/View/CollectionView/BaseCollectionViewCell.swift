//
//  BaseCollectionViewCell.swift
//  Pass
//
//  Created by 강민석 on 2021/05/25.
//

import UIKit

import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    // MARK: Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
}
