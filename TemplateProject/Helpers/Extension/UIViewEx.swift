//
//  UIViewEx.swift
//  TemplateProject
//
//  Created by Dung Do on 5/7/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

extension UIView {
    
    func setRoundedCornersFull() {
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func setBorderWithRadius(_ radius: Float, color: UIColor) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    func setBorderWithRadius(_ radius: Float, color: UIColor, roundingCorners: UIRectCorner) {
        let rounded = UIBezierPath(roundedRect: self.layer.bounds,
                                   byRoundingCorners: roundingCorners,
                                   cornerRadii: CGSize(width: CGFloat(radius), height: CGFloat(radius)))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
    
    func setShadowWithRadius(_ radius: Float) {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(2.0))
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = CGFloat(radius)
    }
    
}
