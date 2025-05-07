//
//  UIView+Extension.swift
//  Skilliket App
//
//  Created by Usuario on 08/10/24.
//

import UIKit

enum LinePosition {
    case top
    case bottom
}

extension UIView {
    func addLine(position: LinePosition, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        switch position {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
    
    func drawCustomShape() {
        let shapeOffset = self.frame.size.height * 0.25

        //create shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = UIColor.white.cgColor

        self.layer.addSublayer(shapeLayer)

        //create path
        let path = UIBezierPath()

        //top left point
        path.move(to: CGPoint(x: 0, y: 0))

        //top right point
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))

        //bottom right point
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))

        //bottom left
        // path.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.size.height - shapeOffset))

        path.close()

        shapeLayer.path = path.cgPath
    }
}
