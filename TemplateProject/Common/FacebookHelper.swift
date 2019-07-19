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
    
    func login(on vc: UIViewController, complete: @escaping (Dictionary<String, Any>?, Error?)->()) {
        if self.isLogin {
            self.fetchMe(complete: complete)
            return
        }
        
        self.loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: vc) { (loginResult) in
            switch loginResult {
            case .success( _, _, _):
                self.fetchMe(complete: complete)
            case .failed(let error):
                complete(nil, error)
            case .cancelled:
                complete(nil, nil)
            }
        }
    }
    
    func logout() {
        self.loginManager.logOut()
    }
    
    private func fetchMe(complete: @escaping (Dictionary<String, Any>?, Error?)->()) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)) { response, result in
            switch result {
            case .success(let response):
                complete(response.dictionaryValue, nil)
            case .failed(let error):
                complete(nil, error)
            }
        }
        connection.start()
    }
    
}
