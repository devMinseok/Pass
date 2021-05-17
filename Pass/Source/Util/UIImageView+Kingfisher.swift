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

typealias ImageOptions = KingfisherOptionsInfo

enum ImageResult {
    case success(UIImage)
    case failure(Error)
    
    var image: UIImage? {
        if case .success(let image) = self {
            return image
        } else {
            return nil
        }
    }
    
    var error: Error? {
        if case .failure(let error) = self {
            return error
        } else {
            return nil
        }
    }
}

extension UIImageView {
    @discardableResult
    func setImage(
        with resource: Resource?,
        placeholder: UIImage? = nil,
        options: ImageOptions? = nil,
        progress: ((Int64, Int64) -> Void)? = nil,
        completion: ((ImageResult) -> Void)? = nil
    ) -> DownloadTask? {
        var options = options ?? []
        // GIF will only animates in the AnimatedImageView
        if self is AnimatedImageView == false {
            options.append(.onlyLoadFirstFrame)
        }
        
        return self.kf.setImage(
            with: resource,
            placeholder: placeholder,
            options: options,
            progressBlock: progress
        ) { result in
            switch result {
            case let .success(value):
                print("task done")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

extension Reactive where Base: UIImageView {
    func image(placeholder: UIImage? = nil, options: ImageOptions) -> Binder<Resource?> {
        return Binder(self.base) { imageView, resource in
            imageView.setImage(with: resource, placeholder: placeholder, options: options)
        }
    }
}
