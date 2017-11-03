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

    init(frame: CGRect, text: String) {
        self.text = text
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func showSuccess(_ view: UIView, with text: String){
        let redView = SuccessView(frame: view.bounds, text: text)
        redView.isOpaque = false
        redView.isUserInteractionEnabled = false
        
        view.addSubview(redView)
        redView.showAnimated()
    }
    
    override func draw(_ rect: CGRect) {
        let width: CGFloat = 96
        let height: CGFloat = 96
        
        let center = CGPoint(x: round(bounds.size.width / 2),
                             y: round(bounds.size.height / 2))
        
        let boxRect = CGRect(x: center.x - width / 2,
                             y: center.y - height / 2,
                             width: width,
                             height: height)
        
        let roundedBox = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.6).setFill()
        roundedBox.fill()
        
        let image = UIImage(named: "Checkmark")!
        let imagePoint = CGPoint(x: center.x - round(image.size.width / 2),
                                 y: center.y - round(image.size.height / 2) - height / 8)
        image.draw(at: imagePoint)
        
        let attribs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                       NSAttributedStringKey.foregroundColor: UIColor.white]
        let textSize = text.size(withAttributes: attribs)
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2),
                               y: center.y - round(textSize.height / 2) + height / 4)
        text.draw(at: textPoint, withAttributes: attribs)
        
    }
    
    func showAnimated() {
        self.alpha = 0
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        let endState = {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: [], animations: endState, completion: nil)
    }
}
