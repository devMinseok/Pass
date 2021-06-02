//
//  String.swift
//  Pass
//
//  Created by 강민석 on 2021/04/30.
//

import UIKit

extension String {
    func attributing(_ ranges: [String], color: UIColor?) -> NSMutableAttributedString? {
        guard let color = color else { return nil }
        
        let attributedString = NSMutableAttributedString(string: self)
        
        ranges.forEach { range in
            attributedString.addAttribute(.foregroundColor, value: color, range: (self as NSString).range(of: range))
        }
        
        return attributedString
    }
    
    func attributing(_ ranges: [String], font: UIFont?) -> NSMutableAttributedString? {
        guard let font = font else { return nil }
        
        let attributedString = NSMutableAttributedString(string: self)
        
        ranges.forEach { range in
            attributedString.addAttribute(.font, value: font, range: (self as NSString).range(of: range))
        }
        
        return attributedString
    }
    
    func attributing(_ ranges: [String], color: UIColor?, font: UIFont?) -> NSMutableAttributedString? {
        guard
            let color = color,
            let font = font
        else { return nil }
        
        let attributedString = NSMutableAttributedString(string: self)
        
        ranges.forEach { range in
            attributedString.addAttribute(.font, value: font, range: (self as NSString).range(of: range))
            attributedString.addAttribute(.foregroundColor, value: color, range: (self as NSString).range(of: range))
        }
        
        return attributedString
    }
}
