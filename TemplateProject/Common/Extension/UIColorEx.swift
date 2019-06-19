//
//  Color.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 5/7/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

extension UIColor {
    
    // Ex: UIColor(r: 95, g: 100, b: 105)
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
    }
    
    // Ex: UIColor(hex: 0x5fc7dc)
    convenience init(hex: Int) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: 0xff)
    }
    
}
