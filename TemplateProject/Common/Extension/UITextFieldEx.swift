//
//  UITextFieldEx.swift
//  IDareU
//
//  Created by Dung Do on 7/17/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import UIKit

extension UITextField {

    @IBInspectable
    var charSpacing: CGFloat {
        set {
            defaultTextAttributes[NSAttributedString.Key.kern] = newValue
        }
        get {
            if let currentCharacterSpace = defaultTextAttributes[NSAttributedString.Key.kern] as? CGFloat {
                return currentCharacterSpace
            } else {
                return 0
            }
        }
    }

}
