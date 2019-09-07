//
//  AlertHelper.swift
//  TemplateProject
//
//  Created by Dung Do on 5/9/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

struct AlertHelper {
    
    private init() {}
    
    static func showPopup(on viewController: UIViewController,
                          title: String,
                          message: String?,
                          mainButton: String,
                          mainComplete: ((UIAlertAction)->())?,
                          otherButton: String? = nil,
                          otherComplete: ((UIAlertAction)->())? = nil) {
        let popup = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        if message != nil && message != "" {
            popup.message = message
        }
        
        let mainAction = UIAlertAction(title: mainButton, style: .default, handler: mainComplete)
        popup.addAction(mainAction)
        
        if let otherButton = otherButton {
            let otherAction = UIAlertAction(title: otherButton, style: .cancel, handler: otherComplete)
            popup.addAction(otherAction)
        }
        
        viewController.present(popup, animated: true, completion: nil)
    }
    
    static func showActionSheet(on viewController: UIViewController,
                                title: String,
                                message: String?,
                                firstButton: String,
                                firstComplete: ((UIAlertAction)->())?,
                                secondButton: String? = nil,
                                secondComplete: ((UIAlertAction)->())? = nil,
                                thirdButton: String? = nil,
                                thirdComplete: ((UIAlertAction)->())? = nil) {
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        if message != nil && message != "" {
            actionSheet.message = message
        }
        
        let firstAction = UIAlertAction(title: firstButton, style: .default, handler: firstComplete)
        actionSheet.addAction(firstAction)
        
        if let secondButton = secondButton {
            let secondAction = UIAlertAction(title: secondButton, style: .default, handler: secondComplete)
            actionSheet.addAction(secondAction)
        }
        if let thirdButton = thirdButton {
            let thirdAction = UIAlertAction(title: thirdButton, style: .default, handler: thirdComplete)
            actionSheet.addAction(thirdAction)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if !K.isIphone {
            if let popOver = actionSheet.popoverPresentationController {
                popOver.sourceView = viewController.view
                popOver.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
                popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
        }
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
}
