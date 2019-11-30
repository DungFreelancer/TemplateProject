//
//  UIButtonEx.swift
//  IDareU
//
//  Created by Dung Do on 7/17/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable
    var charSpacing: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = self.titleLabel?.attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            } else {
                attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
                self.titleLabel?.text = nil
            }
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            self.titleLabel?.attributedText = attributedString
        }
        get {
            if let currentCharacterSpace = self.titleLabel?.attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentCharacterSpace
            } else {
                return 0
            }
        }
    }
    
    override open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        
        self.isUserInteractionEnabled = false
        Utils.delay(0.5) {
            self.isUserInteractionEnabled = true
        }
    }
    
}
