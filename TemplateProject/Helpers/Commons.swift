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
    
}
