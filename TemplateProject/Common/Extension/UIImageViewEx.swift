//
//  UIImageEX.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/4/17.
//  Copyright © 2017 HD. All rights reserved.
//

import Kingfisher

extension UIImageView {
    
    func download(from url: String, complete:((Bool, String?)->())? = nil) {
        // Set default Ram cache size to 300 MB.
//        ImageCache.default.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
        // Set default Disk cache size to 1 GB.
//        ImageCache.default.diskStorage.config.sizeLimit = 1000 * 1024 * 1024
        
        self.kf.indicatorType = .activity
        
        self.kf.cancelDownloadTask()
        self.kf.setImage(with: URL(string: url),
                         placeholder: nil,
                         options: [
                             .processor(DownsamplingImageProcessor(size: self.frame.size)),
                             .scaleFactor(UIScreen.main.scale),
                             .cacheOriginalImage
                         ],
                         progressBlock: nil) { (result) in
            if complete != nil {
                switch result {
                case .success(_):
                    complete!(true, nil)
                case .failure(let error):
                    complete?(false, error.errorDescription)
                }
            }
        }
    }
    
}

