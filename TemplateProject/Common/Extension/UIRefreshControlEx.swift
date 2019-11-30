//
//  UIRefreshControlEx.swift
//  TemplateProject
//
//  Created by Dung Do on 11/30/19.
//  Copyright © 2019 HD. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    
    override open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        
        Utils.delay(5) {
            if self.isRefreshing {
                self.endRefreshing()
            }
        }
    }
    
}
