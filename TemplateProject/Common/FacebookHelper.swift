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
    
//    static let shared = FacebookHelper()
//    private let loginManager = LoginManager()
//
//    var isLogin: Bool {
//        if let _ = AccessToken.current {
//            return true
//        }
//        return false
//    }
//
//    private init() {}
//
//    func loginFacebook(on vc: UIViewController, complete: @escaping (Bool)->()) {
//        if self.isLogin {
//            Log.debug("User logged in")
//            complete(true)
//            return
//        }
//
//        self.loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: vc) { (loginResult) in
//            switch loginResult {
//            case .success( _, _, _):
//                Log.debug("User logged in")
//                complete(true)
//            case .failed(let error):
//                Log.error(error)
//                complete(false)
//            case .cancelled:
//                Log.debug("User cancelled login")
//                complete(false)
//            }
//        }
//    }
//
//    func logoutFacebook() {
//        Log.debug("User logged out")
//        self.loginManager.logOut()
//    }
//
//    func fetchMeWithFacebook(complete: @escaping (Bool, Dictionary<String, Any>?)->()) {
//        if !self.isLogin {
//            Log.debug("User not logged in")
//            complete(false, nil)
//            return
//        }
//
//        let connection = GraphRequestConnection()
//        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)) { response, result in
//            switch result {
//            case .success(let response):
//                Log.debug(response)
//                complete(true, response.dictionaryValue)
//            case .failed(let error):
//                Log.error(error)
//                complete(false, nil)
//            }
//        }
//        connection.start()
//    }
    
}
