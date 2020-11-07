//
//  AppleHelper.swift
//  IDareU
//
//  Created by Dung Do on 11/7/20.
//  Copyright © 2020 Dung Do. All rights reserved.
//

import Foundation
import AuthenticationServices

class AppleHelper: NSObject, ASAuthorizationControllerDelegate {
    
    static let shared = AppleHelper()
    
    private var complete: ((Dictionary<String, Any>?, Error?)->())?
    
    private override init() {}
    
    func login(on vc: UIViewController, complete: ((Dictionary<String, Any>?, Error?)->())?) {
        self.complete = complete
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let appleIDToken = appleIDCredential.identityToken,
           let token = String(data: appleIDToken, encoding: .utf8) {
            var data: Dictionary<String, Any> = [:]
            data["userId"] = appleIDCredential.user
            data["name"] = appleIDCredential.fullName
            data["email"] = appleIDCredential.email
            data["accessToken"] = token
            
            self.complete?(data, nil)
        } else {
            self.complete?(nil, nil)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.complete?(nil, error)
    }
    
}
