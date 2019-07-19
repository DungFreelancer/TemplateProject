//
//  GoogleHelper.swift
//  IDareU
//
//  Created by Dung Do on 6/20/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import GoogleSignIn

class GoogleHelper: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    static let clientID = "330883660964-ntdu9rng54bd2jebvbfqp40jud55g7i1.apps.googleusercontent.com"
    
    static let shared = GoogleHelper()
    
    private let loginManager = GIDSignIn.sharedInstance()!
    
    private var complete: ((Dictionary<String, Any>?, Error?)->())?
    
    private var vc: UIViewController?
    
    var isLogin: Bool {
        if let user = loginManager.currentUser, let _ = user.authentication {
            return true
        }
        return false
    }
    
    private override init() {}
    
    func login(on vc: UIViewController, complete: @escaping (Dictionary<String, Any>?, Error?)->()) {
        self.complete = complete
        self.vc = vc
        
        self.loginManager.delegate = self
        self.loginManager.uiDelegate = self
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
            
            self.complete!(data, nil)
        }
    }
    
    // MARK: - GIDSignInUIDelegate
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.vc?.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.vc?.dismiss(animated: true, completion: nil)
    }
    
}
