//
//  Utils.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/1/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit

struct Utils {
    
    private init() {}
    
    static func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    static func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        return "v\(version)(\(build))"
    }
    
    static func removePersisDomain() {
        let appDomain: String = Bundle.main.bundleIdentifier!
        K.userDefault.removePersistentDomain(forName: appDomain)
    }
    
    static func delay(_ duration: Double, call function: @escaping () -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            function()
        }
    }
    
    static func checkValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email.trim())
    }
    
    static func checkValid(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password.trim())
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
