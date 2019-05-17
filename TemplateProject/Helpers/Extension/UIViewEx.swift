//
//  UIViewEx.swift
//  TemplateProject
//
//  Created by Dung Do on 5/7/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

extension UIView {
    
    var width: CGFloat {
        return self.frame.width;
    }
    
    var height: CGFloat {
        return self.frame.height;
    }
    
    var x: CGFloat {
        return self.frame.origin.x
    }
    
    var y: CGFloat {
        return self.frame.origin.y
    }
    
    func setRoundedCornersFull() {
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func setBorderWithRadius(_ radius: Double, color: UIColor) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    func setBorderWithRadius(_ radius: Double, color: UIColor, roundingCorners: UIRectCorner) {
        let rounded = UIBezierPath(roundedRect: self.layer.bounds,
                                   byRoundingCorners: roundingCorners,
                                   cornerRadii: CGSize(width: CGFloat(radius), height: CGFloat(radius)))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
    
    func setShadowWithRadius(_ radius: Double) {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = CGFloat(radius)
        self.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func captureImage() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
