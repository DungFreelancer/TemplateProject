//
//  UIViewEx.swift
//  TemplateProject
//
//  Created by Dung Do on 5/7/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.size.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newValue)
        }
    }
    
    func setRoundedCornersFull() {
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func setBorder(radius: Double, color: UIColor) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    func setBorder(radius: Double, color: UIColor, roundingCorners: UIRectCorner) {
        let rounded = UIBezierPath(roundedRect: self.layer.bounds,
                                   byRoundingCorners: roundingCorners,
                                   cornerRadii: CGSize(width: CGFloat(radius), height: CGFloat(radius)))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
    
    func setShadow(radius: Double) {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = CGFloat(radius)
        self.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func setGradient(startColor: UIColor, startPoint: CGPoint, endColor: UIColor, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func captureImage() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
