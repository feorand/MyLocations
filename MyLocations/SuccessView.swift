//
//  SuccessView.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 02.10.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit

class SuccessView: UIView {
    var text = ""
    
    class func red(_ view: UIView) -> SuccessView {
        let redView = SuccessView(frame: view.bounds)
        redView.isOpaque = false
        redView.isUserInteractionEnabled = false
        
        view.addSubview(redView)
        return redView
    }
    
    override func draw(_ rect: CGRect) {
        let width: CGFloat = 96
        let height: CGFloat = 96
        
        let boxRect = CGRect(x: (bounds.width - width) / 2,
                             y: (bounds.height - height) / 2,
                             width: width,
                             height: height)
        
        let roundedBox = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.6).setFill()
        roundedBox.fill()
        
        let image = UIImage(named: "Checkmark")!
        let imagePoint = CGPoint(x: center.x - round(image.size.width / 2),
                                 y: center.y + round(image.size.height / 2))
        image.draw(at: imagePoint)
        
    }
}
