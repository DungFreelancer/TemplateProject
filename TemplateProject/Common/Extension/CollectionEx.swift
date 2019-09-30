//
//  CollectionEx.swift
//  TemplateProject
//
//  Created by apple on 9/30/19.
//  Copyright © 2019 HD. All rights reserved.
//

import Foundation

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
