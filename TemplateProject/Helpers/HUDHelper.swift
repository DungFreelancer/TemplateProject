//
//  HUDHelper.swift
//  TemplateProject
//
//  Created by Dung Do on 10/9/17.
//  Copyright © 2017 HD. All rights reserved.
//

import PKHUD

class HUDHelper {
    
    static let sharedInstance = HUDHelper()
    
    private init() {}
    
    func showLoading(view: UIView) {
        PKHUD.sharedHUD.contentView = ProgressView()
        PKHUD.sharedHUD.show(onView: view)
    }
    
    func hideLoading() {
        PKHUD.sharedHUD.hide()
    }
    
    class ProgressView: PKHUDProgressView {
        override func layoutSubviews() {
            super.layoutSubviews()
            
            imageView.frame = CGRect(origin: CGPoint(x:0.0, y:0.0), size: CGSize(width: 100, height: 100))
        }
        
        convenience init() {
            self.init(title: nil, subtitle: nil)
            
            self.frame = CGRect(origin: CGPoint(x:0.0, y:0.0), size: CGSize(width: 100, height: 100))
        }
    }
    
}
