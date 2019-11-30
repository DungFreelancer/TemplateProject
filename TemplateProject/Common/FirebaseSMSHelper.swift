//
//  FirebaseSMSHelper.swift
//  TemplateProject
//
//  Created by Dung Do on 11/30/19.
//  Copyright © 2019 HD. All rights reserved.
//

import FirebaseAuth
import Firebase

class FirebaseSMSHelper {
    
    static let shared = FirebaseSMSHelper()
    
    func verifyPhoneNumber(phoneNumber: String, complete: @escaping (String?, String?)->()) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                complete(nil, error.localizedDescription)
            } else if let verificationID = verificationID {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                complete(verificationID, nil)
            }
        }
    }
    
    func verificationCode(verificationID: String, verificationCode: String, complete: @escaping (String?, String?)->()) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                complete(nil, error.localizedDescription)
            } else {
                authResult?.user.getIDTokenResult(completion: { (AuthTokenResult, Error) in
                    if let AuthTokenResult = AuthTokenResult {
                        complete( AuthTokenResult.token, nil)
                    }
                })
            }
        }
    }
    
}
