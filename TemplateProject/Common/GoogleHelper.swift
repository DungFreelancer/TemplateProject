//
//  GoogleHelper.swift
//  IDareU
//
//  Created by Dung Do on 6/20/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import GoogleSignIn

class GoogleHelper: NSObject, GIDSignInDelegate {
    
    static let clientID = "601387200679-mbe30uea2pir2d8f8htk30hhkuqvbk4v.apps.googleusercontent.com"
    
    static let shared = GoogleHelper()
    
    private let loginManager = GIDSignIn.sharedInstance()!
    
    private var complete: ((Dictionary<String, Any>?, Error?)->())?
    
    var isLogin: Bool {
        if let user = loginManager.currentUser, let _ = user.authentication {
            return true
        }
        return false
    }
    
    private override init() {}
    
    func login(on vc: UIViewController, complete: @escaping (Dictionary<String, Any>?, Error?)->()) {
        self.complete = complete
        
        self.loginManager.delegate = self
        self.loginManager.presentingViewController = vc
        self.loginManager.signIn()
    }
    
    func logout() {
        self.loginManager.signOut()
    }
    
    // MARK: - GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if !self.isLogin {
            self.complete!(nil, nil)
            return
        }
        
        if let error = error {
            self.complete!(nil, error)
        } else {
            var data: Dictionary<String, Any> = [:]
            data["userId"] = user.userID
            data["name"] = user.profile.name
            data["email"] = user.profile.email
            data["accessToken"] = user.authentication.accessToken
            
            self.complete!(data, nil)
        }
    }
    
}
