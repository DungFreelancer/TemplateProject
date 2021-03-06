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
    
    static func removePersisDomain() {
        let appDomain: String = Bundle.main.bundleIdentifier!
        K.userDefault.removePersistentDomain(forName: appDomain)
    }
    
    static func applicationDocumentDirectoryString() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        return documentDirectory
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
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\W\\d]{8,}$"
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
    
    static func object<T: Decodable>(from data: Data, type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            Log.e(error)
            return nil
        }
    }
    
    static func data<T: Encodable>(from object: T) -> Data? {
        do {
            return try JSONEncoder().encode(object)
        } catch {
            Log.e(error)
            return nil
        }
    }
    
}

