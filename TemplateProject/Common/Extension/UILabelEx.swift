//
//  UILabelEx.swift
//  IDareU
//
//  Created by Dung Do on 7/17/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import UIKit

extension UILabel {
    
    @IBInspectable
    var charSpacing: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            } else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
        get {
            if let currentCharacterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentCharacterSpace
            } else {
                return 0
            }
        }
    }
    
}
