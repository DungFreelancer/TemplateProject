//
//  AlertHelper.swift
//  TemplateProject
//
//  Created by Dung Do on 5/9/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class AlertHelper {
    
    static let sharedInstance = AlertHelper()
    
    private init() {}
    
    func showPopupOnViewController(_ viewController: UIViewController,
                                   title: String? = nil,
                                   message: String,
                                   mainButton: String,
                                   mainComplete: @escaping (UIAlertAction)->(),
                                   otherButton: String? = nil,
                                   otherComplete: ((UIAlertAction)->())? = nil) {
        let popup = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        if title != nil && title != "" {
            popup.title = title
        }
        
        let mainAction = UIAlertAction(title: mainButton, style: .default, handler: mainComplete)
        popup.addAction(mainAction)
        
        if let otherButton = otherButton {
            let otherAction = UIAlertAction(title: otherButton, style: .cancel, handler: otherComplete)
            popup.addAction(otherAction)
        }
        
        viewController.present(popup, animated: true, completion: nil)
    }
    
    func showActionSheetOnViewController(_ viewController: UIViewController,
                                         title: String? = nil,
                                         message: String? = nil,
                                         firstButton: String,
                                         firstComplete: @escaping (UIAlertAction)->(),
                                         secondButton: String? = nil,
                                         secondComplete: ((UIAlertAction)->())? = nil,
                                         thirdButton: String? = nil,
                                         thirdComplete: ((UIAlertAction)->())? = nil) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if title != nil && title != "" {
            actionSheet.title = title
        }
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
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
}