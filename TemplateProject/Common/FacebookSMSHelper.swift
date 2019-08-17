//
//  FacebookSMSHelper.swift
//  IDareU
//
//  Created by Dung Do on 8/8/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import AccountKit

class FacebookSMSHelper: NSObject, AKFViewControllerDelegate {
    
    static let shared = FacebookSMSHelper()
    
    private var accountKit = AccountKit(responseType: .accessToken)
    
    private var complete: ((Dictionary<String, Any>?, Error?)->())?
    
    var isLogin: Bool {
        if let _ = self.accountKit.currentAccessToken {
            return true
        }
        return false
    }
    
    private override init() {}
    
    func login(on vc: UIViewController, complete: @escaping (Dictionary<String, Any>?, Error?)->()) {
        if self.isLogin {
            let data = ["accessToken": self.accountKit.currentAccessToken!.tokenString]
            complete(data, nil)
            return
        }
        
        self.complete = complete
        
        let vcSMS = (self.accountKit.viewControllerForPhoneLogin(with: nil, state: UUID().uuidString))
        vcSMS.delegate = self
        vcSMS.uiManager = SkinManager(skinType: .classic, primaryColor: UIColor.orange)
        vc.present(vcSMS, animated: true, completion: nil)
    }
    
    func logout() {
        self.accountKit.logOut()
    }
    
    // MARK: - AKFViewControllerDelegate
    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith accessToken: AccessToken, state: String) {
        let data = ["accessToken": accessToken.tokenString]
        self.complete!(data, nil)
    }
    
    func viewController(_ viewController: UIViewController & AKFViewController, didFailWithError error: Error) {
        self.complete!(nil, error)
    }
    
}
