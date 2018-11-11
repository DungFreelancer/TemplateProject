//
//  AppError.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/23/18.
//  Copyright © 2018 HD. All rights reserved.
//

import Foundation

protocol AppError: Error {
    var title: String { get }
    var description: String { get }
    
    // write an extension to convest AppError to NSError
}

protocol hasInstructions {
    var instruction: String? { get }
}
