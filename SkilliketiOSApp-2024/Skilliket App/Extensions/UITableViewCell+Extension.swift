//
//  UITableViewCell+Extension.swift
//  Skilliket App
//
//  Created by Usuario on 12/10/24.
//

import UIKit

extension UITableViewCell {
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}
