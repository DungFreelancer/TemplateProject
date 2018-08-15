//
//  NetworkHelper.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/4/17.
//  Copyright © 2017 HD. All rights reserved.
//

import Alamofire
import SwiftyJSON

class NetworkHelper {
    
    static let sharedInstance = NetworkHelper()
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
    
    func get(url: String, complete:((_ success: JSON?,_ error: Error?)->())?) {
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            self.respone(result: response.result, complete: complete)
        }
    }
    
    func post(url: String, params: Dictionary<String, Any>, complete:((_ success: JSON?,_ error: Error?)->())?) {
        Alamofire.request(url, method: .post, parameters: params).validate().responseJSON { response in
            self.respone(result: response.result, complete: complete)
        }
    }
    
    private func respone(result: Result<Any>, complete: ((_ success: JSON?,_ error: Error?)->())?) {
        guard let complete = complete else {
            return
        }
        
        switch result {
        case .success(let value):
            let json = JSON(value)
            complete(json, nil)
        case .failure(let error):
            complete(nil, error)
        }
    }
    
}

