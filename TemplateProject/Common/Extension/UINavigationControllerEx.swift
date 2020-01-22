//
//  UINavigationControllerEx.swift
//  TemplateProject
//
//  Created by Dung Do on 1/22/20.
//  Copyright © 2020 HD. All rights reserved.
//

import Foundation

import UIKit

extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(numberOfVC: Int, animated: Bool = true) {
        if viewControllers.count > numberOfVC {
            let vc = viewControllers[viewControllers.count - numberOfVC - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
}
