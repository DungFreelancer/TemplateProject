//
//  FacebookHelper.swift
//  IDareU
//
//  Created by Dung Do on 6/20/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import FacebookCore
import FacebookLogin

class FacebookHelper {
    
    static let shared = FacebookHelper()
    
    private let loginManager = LoginManager()
    
    var isLogin: Bool {
        if let _ = AccessToken.current {
            return true
        }
        return false
    }
    
    private init() {}
    
    func loginFacebook(on vc: UIViewController, complete: @escaping (Bool, Dictionary<String, Any>?)->()) {
        if self.isLogin {
            self.fetchMeWithFacebook(complete: complete)
            return
        }
        
        self.loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: vc) { (loginResult) in
            switch loginResult {
            case .success( _, _, _):
                Log.d("User logged in")
                self.fetchMeWithFacebook(complete: complete)
            case .failed(let error):
                Log.e(error)
                complete(false, nil)
            case .cancelled:
                Log.d("User cancelled login")
                complete(false, nil)
            }
        }
    }
    
    func logoutFacebook() {
        Log.d("User logged out")
        self.loginManager.logOut()
    }
    
    private func fetchMeWithFacebook(complete: @escaping (Bool, Dictionary<String, Any>?)->()) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)) { response, result in
            switch result {
            case .success(let response):
                Log.d(response)
                complete(true, response.dictionaryValue)
            case .failed(let error):
                Log.e(error)
                complete(false, nil)
            }
        }
        connection.start()
    }
    
}
