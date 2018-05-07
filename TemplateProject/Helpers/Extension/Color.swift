//
//  Color.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 5/7/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
