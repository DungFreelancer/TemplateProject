//
//  Log.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/1/17.
//  Copyright © 2017 HD. All rights reserved.
//

import Foundation

struct Log {
    
    static func debug(_ message: Any, filePath: String = #file, function: String = #function, line: Int = #line) {
        if DEBUG {
            let fileName = filePath.components(separatedBy: "/").last!
            print("🔵\(fileName)" + "_" + "\(function)[line \(line)]: \(message)🔵")
        }
    }
    
    static func error(_ message: Any, filePath: String = #file, function: String = #function, line: Int = #line) {
        if DEBUG {
            let fileName = filePath.components(separatedBy: "/").last!
            print("🔴\(fileName)" + "_" + "\(function)[line \(line)]: \(message)🔴")
        }
    }
    
}
