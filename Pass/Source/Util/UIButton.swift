//
//  UIButton.swift
//  Pass
//
//  Created by 강민석 on 2021/04/30.
//

import UIKit

class CustomButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            if oldValue == false && isHighlighted {
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 0.7
                }
            } else if oldValue == true && !isHighlighted {
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 1
                }
            }
        }
    }
}
