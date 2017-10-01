//
//  Commons.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/1/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit

class Commons {
    
    static let sharedInstance: Commons = Commons()
    
    private init() {}
    
    func removePersisDomain() {
        let appDomain: String = Bundle.main.bundleIdentifier!
        USER_DEFAULT.removePersistentDomain(forName: appDomain)
    }
    
    func applicationDocumentDirectoryString() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func showAlertOnViewController(_ viewController: UIViewController,
                                   title: String? = nil,
                                   message: String,
                                   mainButton: String,
                                   mainComplete: @escaping (UIAlertAction)->(),
                                   otherButton: String? = nil,
                                   otherComplete: ((UIAlertAction)->())? = nil) {
        let alert: UIAlertController
        
        if title == nil || title == "" {
            alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        }
        
        let mainAction = UIAlertAction(title: mainButton, style: .default, handler: mainComplete)
        alert.addAction(mainAction)
        
        if let otherButton = otherButton {
            let otherAction = UIAlertAction(title: otherButton, style: .cancel, handler: otherComplete)
            alert.addAction(otherAction)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
