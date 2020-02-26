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
    
    func cancelAll() {
        Alamofire.Session.default.session.getAllTasks { (tasks) in
            tasks.forEach{ $0.cancel() }
        }
    }
    
    func connectionStatusChange(_ isConnected: @escaping (Bool)->()) {
        self.reachabilityManager?.startListening(onUpdatePerforming: { (status) in
            if (status != .unknown && status != .notReachable) {
                isConnected(true)
            } else {
                isConnected(false)
            }
        })
    }
    
    private func initHeaders(headers: Dictionary<String, String>?) -> HTTPHeaders? {
        if let headers = headers {
            return HTTPHeaders(headers)
        }
//        if let accessToken = K.accessToken {
//            return HTTPHeaders(["Authorization" : accessToken])
//        }
        return nil
    }

    
    func get<T: Decodable>(url: String, headers: Dictionary<String, String>? = nil, type: T.Type, complete:((_ data: T?,_ error: Error?)->())?) {
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: self.initHeaders(headers: headers)).responseJSON { (response) in
            self.response(response, type: type, complete: complete)
        }
    }
    
    func post<T: Decodable>(url: String, params: Dictionary<String, Any>, headers: Dictionary<String, String>? = nil, type: T.Type, complete:((_ data: T?,_ error: Error?)->())?) {
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.initHeaders(headers: headers)).responseJSON { (response) in
            self.response(response, type: type, complete: complete)
        }
    }
    
    private func response<T: Decodable>(_ response: AFDataResponse<Any>, type: T.Type, complete: ((_ data: T?,_ error: Error?)->())?) {
        guard let complete = complete else {
            return
        }
        
        switch response.result {
        case .success( _):
            let data = try? JSONDecoder().decode(T.self, from: response.data!)
            complete(data, nil)
        case .failure(let error):
            complete(nil, error)
        }
    }
    
    func get(url: String, headers: Dictionary<String, String>? = nil, complete:((_ data: JSON?,_ error: Error?)->())?) {
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: self.initHeaders(headers: headers)).responseJSON { (response) in
            self.response(response, complete: complete)
        }
    }
    
    func post(url: String, params: Dictionary<String, Any>, headers: Dictionary<String, String>? = nil, complete:((_ data: JSON?,_ error: Error?)->())?) {
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.initHeaders(headers: headers)).responseJSON { (response) in
            self.response(response, complete: complete)
        }
    }
    
    func upload(_ arrData: [Data], to url: String, headers: Dictionary<String, String>? = nil, complete:((_ data: JSON?,_ error: Error?)->())?) {
        AF.upload(multipartFormData: { (multipartFormData) in
            for i in 0 ..< arrData.count {
                multipartFormData.append(arrData[i], withName: "image", fileName: "image\(i).png", mimeType: "image/png")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: self.initHeaders(headers: headers)).responseJSON { (response) in
            self.response(response, complete: complete)
        }
    }
    
    private func response(_ response: AFDataResponse<Any>, complete: ((_ data: JSON?,_ error: Error?)->())?) {
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

