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
    
    static let shared = NetworkHelper()
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    var isConnect: Bool? {
        return NetworkReachabilityManager()?.isReachable
    }
    
    private init() {}
    
    func connectionStatusChange(_ isConnected: @escaping (Bool)->()) {
        reachabilityManager?.listener = { status in
            if (status != .unknown && status != .notReachable) {
                isConnected(true)
            } else {
                isConnected(false)
            }
        }
        reachabilityManager?.startListening()
    }
    
    func get<T: Decodable>(url: String, header: Dictionary<String, String>? = nil, type: T.Type, complete:((_ data: T?,_ error: Error?)->())?) {
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            self.response(response, type: type, complete: complete)
        }
    }
    
    func post<T: Decodable>(url: String, params: Dictionary<String, Any>, header: Dictionary<String, String>? = nil, type: T.Type, complete:((_ data: T?,_ error: Error?)->())?) {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            self.response(response, type: type, complete: complete)
        }
    }
    
    private func response<T: Decodable>(_ response: DataResponse<Any>, type: T.Type, complete: ((_ data: T?,_ error: Error?)->())?) {
        guard let complete = complete else {
            return
        }
        
        switch response.result {
        case .success( _):
            let data = try! JSONDecoder().decode(T.self, from: response.data!)
            complete(data, nil)
        case .failure(let error):
            complete(nil, error)
        }
    }
    
    func get(url: String, header: Dictionary<String, String>? = nil, complete:((_ data: JSON?,_ error: Error?)->())?) {
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            self.response(response, complete: complete)
        }
    }
    
    func post(url: String, params: Dictionary<String, Any>, header: Dictionary<String, String>? = nil, complete:((_ data: JSON?,_ error: Error?)->())?) {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            self.response(response, complete: complete)
        }
    }
    
    private func response(_ response: DataResponse<Any>, complete: ((_ data: JSON?,_ error: Error?)->())?) {
        guard let complete = complete else {
            return
        }
        
        switch response.result {
        case .success(let value):
            complete(JSON(value), nil)
        case .failure(let error):
            complete(nil, error)
        }
    }
    
}

