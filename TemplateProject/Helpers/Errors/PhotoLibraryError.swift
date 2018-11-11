//
//  PhotoLibraryError.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/23/18.
//  Copyright © 2018 HD. All rights reserved.
//

import Foundation

enum PhotoLibraryError: AppError {
    
    case saveFailed
    
    var title: String {
        return "Error!"
    }
    var description: String {
        switch self {
        case .saveFailed:
            return "Sorry, we were not able to save your photo to your phone."
        }
    }
}
