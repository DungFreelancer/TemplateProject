//
//  Constants.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/1/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit

struct K {
    
    private init() {}
    
    static let debug = true
    
    static let userDefault: UserDefaults = UserDefaults.standard
    
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let screenSize: CGSize = UIScreen.main.bounds.size
    
    static let isIphone: Bool = UIDevice.current.model == "iPhone"
    
    static let isLandscape: Bool = UIApplication.shared.statusBarOrientation.isLandscape
    
    static let isSimulator: Bool = Bool(exactly: TARGET_OS_SIMULATOR as NSNumber)!
    
    static var iOS: Int {
        get {
            let currentOS = UIDevice.current.systemVersion
            let index = currentOS.firstIndex(of: ".") ?? currentOS.endIndex
            return Int(currentOS[..<index])!
        }
    }
    
    struct Screens {
        static let ViewControllers = "ViewControllers"
    }
    
    struct Keys {
        static let isFirstLaunch = "isFirstLaunch"
    }
    
    struct URLs {
        static let base               = K.debug ? "https://api-dev.idareu.dirox.dev/api/v1/" : "https://api.idareu.dirox.dev/api/v1/"
        static var Category           = base + "Category"
    }
    
}
