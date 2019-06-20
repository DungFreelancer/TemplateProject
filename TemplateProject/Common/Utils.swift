//
//  Utils.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/1/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit

class Utils {
    
    private init() {}
    
    static func removePersisDomain() {
        let appDomain: String = Bundle.main.bundleIdentifier!
        USER_DEFAULT.removePersistentDomain(forName: appDomain)
    }
    
    static func applicationDocumentDirectoryString() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    static func dellay(_ duration: Double, call function: @escaping () -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            function()
        }
    }
    
    static func getViewFromXib(name: String) -> UIView? {
        return UINib.init(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }
    
    static func getViewController(name: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: name)
        return vc
    }
    
}