//
//  CBKCurvedView.swift
//  Commons_APPCBK
//
//  Created by Alexandre Martinez on 1/8/17.
//  Copyright © 2017 opentrends. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class CBKCurvedView: UIView {

    private let cbkBlue:UIColor = .blueCaixa1
    private var curvedLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }

    private func configureView() {
        self.backgroundColor = UIColor.clear
        let fillColor = cbkBlue

        let layer = CAShapeLayer()
        layer.fillColor = fillColor.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = 0
        self.layer.addSublayer(layer)
        curvedLayer = layer
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.curvedLayer?.path = pathOfArcWithinSize(self.bounds.size)?.cgPath
    }

    func pathOfArcWithinSize(_ size: CGSize) -> UIBezierPath? {
        var path: UIBezierPath?

        guard size.width != 0 && size.height > 0 else {
            return path
        }

        let theta = .pi - atan2(size.width / 2.0, size.height) * 2.0
        let radius = self.bounds.size.height / (1.0 - cos(theta))
        path = UIBezierPath()
        path?.move(to: CGPoint(x: 0, y: -10))
        path?.addLine(to: CGPoint(x: 0, y: 0))
        path?.addArc(withCenter: CGPoint(x: size.width / 2.0, y: -radius + size.height), radius: radius, startAngle: .pi / 2 + theta, endAngle: .pi / 2 - theta, clockwise: false)
        path?.addLine(to: CGPoint(x: size.width, y: -10))
        path?.addLine(to: CGPoint(x: 0, y: -10))
        path?.close()

        return path
    }
}
