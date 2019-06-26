//
//  HUDHelper.swift
//  TemplateProject
//
//  Created by Dung Do on 10/9/17.
//  Copyright © 2017 HD. All rights reserved.
//

import PKHUD

struct HUDHelper {
    
    private init() {}
    
    static func showLoading(on view:UIView? = K.appDelegate.window?.rootViewController?.view) {
        PKHUD.sharedHUD.contentView = ProgressView()
        PKHUD.sharedHUD.show(onView: view)
    }
    
    static func hideLoading() {
        PKHUD.sharedHUD.hide()
    }
    
    private class ProgressView: PKHUDProgressView {
        
         let frameSize = 100
         let imageSize = 40
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let center = (self.frameSize - self.imageSize) / 2
            self.imageView.frame = CGRect(x: center, y: center, width: self.imageSize, height: self.imageSize)
            self.imageView.contentMode = .scaleAspectFill
        }
        
        convenience init() {
            self.init(title: nil, subtitle: nil)
            
            self.frame = CGRect(x: 0, y: 0, width: self.frameSize, height: self.frameSize)
        }
        
    }
    
}
