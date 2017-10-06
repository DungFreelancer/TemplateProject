//
//  NetworkHelper.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/4/17.
//  Copyright © 2017 HD. All rights reserved.
//

import Alamofire

class NetworkHelper {
    
    static let sharedInstance = NetworkHelper ()
    private let reachabilityManager = NetworkReachabilityManager()
    var isConnect: Bool? {
        return NetworkReachabilityManager()?.isReachable
    }
    
    private init() {}
    
    func connectingChange(_ connected: @escaping (Bool)->()) {
        reachabilityManager?.listener = { status in
            if (status != .unknown && status != .notReachable) {
                connected(true)
            } else {
                connected(false)
            }
        }
        reachabilityManager?.startListening()
    }
    
}
