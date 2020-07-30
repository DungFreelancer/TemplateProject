//
//  UIButtonEx.swift
//  IDareU
//
//  Created by Dung Do on 7/17/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import UIKit

extension UIButton {
    
    override open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        
        self.isUserInteractionEnabled = false
        Utils.delay(0.5) {
            self.isUserInteractionEnabled = true
        }
    }
    
}
