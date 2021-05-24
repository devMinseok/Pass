//
//  UIImageView+Kingfisher.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift

extension Reactive where Base: UIImageView {
    func image(placeholder: UIImage? = nil) -> Binder<Resource?> {
        return Binder(self.base) { imageView, resource in
            imageView.kf.setImage(with: resource, placeholder: placeholder)
        }
    }
}
