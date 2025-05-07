//
//  CustomTableViewCell.swift
//  Skilliket App
//
//  Created by Usuario on 12/10/24.
//
import UIKit

class CustomTableViewCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()

        // Apply insets to the content view
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}
