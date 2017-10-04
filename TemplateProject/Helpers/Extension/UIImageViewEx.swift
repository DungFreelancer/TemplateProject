//
//  UIImageEX.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/4/17.
//  Copyright © 2017 HD. All rights reserved.
//

import Kingfisher

extension UIImageView {
    
    func downloadFromURL(_ url: String) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: url))
    }
    
}
