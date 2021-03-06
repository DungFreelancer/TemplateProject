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
    
    static let userDefault: UserDefaults = UserDefaults.standard
    
    static let net: NetworkHelper = NetworkHelper.shared
    
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let screenSize: CGSize = UIScreen.main.bounds.size
    
    static let isIphone: Bool = UIDevice.current.model == "iPhone"
    
    static let isIphoneX: Bool = K.appDelegate.window!.safeAreaInsets.top > 20.0
    
    static let isLandscape: Bool = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
    
    static let isSimulator: Bool = Bool(exactly: TARGET_OS_SIMULATOR as NSNumber)!
    
    static let deviceID: String? = UIDevice.current.identifierForVendor?.uuidString
    
    static var OS: String = UIDevice.current.systemVersion
    
    static var OSVersion: String = UIDevice.current.systemName
    
    static var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
    static var appVersion: String {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        return "\(version)(\(build))"
    }
    
    static var isLaunchedBefore: Bool {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.isLaunchedBefore)
        }
        get {
            return K.userDefault.bool(forKey: K.Keys.isLaunchedBefore)
        }
    }
    
    static var currentLanguage: Language {
        set {
            K.userDefault.set(newValue.rawValue, forKey: K.Keys.CurrentLanguage)
        }
        get {
            if let lang = K.userDefault.string(forKey: K.Keys.CurrentLanguage) {
                return Language(rawValue: lang) ?? .english
            } else {
                return .english
            }
        }
    }
    
    enum Language: String {
        case english    = "en"
        case french     = "fr"
        case spanish    = "es"
        case russian    = "ru"
        case italian    = "it"
    }
    
    static let defaultDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    static let defaultImageCompression: CGFloat = 0.5
    
    struct AppFont {
        static let Regular  = "SourceSansPro-Regular"
        static let Black    = "SourceSansPro-Black"
        static let Semibold = "SourceSansPro-Semibold"
        static let Light    = "SourceSansPro-Light"
    }
    
    struct Screens {
        static let ViewControllers = "ViewControllers"
    }
    
    struct Keys {
        static let isLaunchedBefore = "isLaunchedBefore"
        static let CurrentLanguage  = "CurrentLanguage"
    }
    
    struct URLs {
        #if DEV
        static let base               = "https://api-dev.idareu.dirox.dev/api/v1"
        #elseif STAGING
        static let base               = "https://api.idareu.dirox.dev/api/v1"
        #else
        static let base               = "https://api.idareu.dirox.dev/api/v1"
        #endif
        
        static var Files              = base + "/Files"
    }
    
}

