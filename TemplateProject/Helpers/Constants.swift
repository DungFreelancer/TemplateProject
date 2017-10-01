//
//  Constants.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/1/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit

let DEBUG = true

let USER_DEFAULT: UserDefaults = UserDefaults.standard

let APP_DELEGATE: AppDelegate = UIApplication.shared.delegate as! AppDelegate

let SCREEN_SIZE: CGSize = UIScreen.main.bounds.size

let IS_IPHONE: Bool = UIDevice.current.model == "iPhone"

let IS_SIMULATOR: Bool = Bool(exactly: TARGET_IPHONE_SIMULATOR as NSNumber)!

var IOS: Int {
    get {
        let currentOS = UIDevice.current.systemVersion
        let index = currentOS.index(of: ".") ?? currentOS.endIndex
        return Int(currentOS[..<index])!
    }
}

