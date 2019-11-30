//
//  TwitterHelper.swift
//  TemplateProject
//
//  Created by Dung Do on 11/30/19.
//  Copyright © 2019 HD. All rights reserved.
//

import TwitterKit

class TwitterHelper{
    
    static let key          = "HzlsX7pm5DptQj8XgSkGSDHQR"
    static let secretKey    = "YAgviCo2Ccu31TqiSq1uA9CtAyNBWVGyzB6MC3YOcA6zUDza11"
    
    static let shared = TwitterHelper()
    
    func login(complete: @escaping (String?,String?, String?)->()) {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                complete(session?.authToken,session?.authTokenSecret, nil)
            } else {
                complete(nil,nil, error?.localizedDescription)
            }
        })
    }
    
    func logout() {
        let store = TWTRTwitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
          store.logOutUserID(userID)
        }
    }
    
}
