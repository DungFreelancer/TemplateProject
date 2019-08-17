//
//  UIImageEX.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/4/17.
//  Copyright © 2017 HD. All rights reserved.
//

import Kingfisher

extension UIImageView {
    
    func download(from url: String, complete:((Bool?, String?)->())? = nil) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: url), placeholder: nil, options: nil, progressBlock: nil) { (result) in
            if complete != nil {
                switch result {
                case .success(_):
                    complete!(true, nil)
                case .failure(let error):
                    complete!(nil, error.localizedDescription)
                }
            }
        }
    }
    
}

