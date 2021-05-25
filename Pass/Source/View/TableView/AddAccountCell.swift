//
//  AddAccountCell.swift
//  Pass
//
//  Created by 강민석 on 2021/05/10.
//

import UIKit

final class AddAccountCell: BaseTableViewCell {
    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView(image: UIImage(systemName: "plus"))
        imageView.tintColor = R.color.textGray()
        self.accessoryView = imageView
        
        self.textLabel?.text = "추가"
        self.textLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        self.textLabel?.textColor = R.color.textGray()
    }
}
