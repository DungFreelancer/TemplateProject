//
//  FileHelper.swift
//  TemplateProject
//
//  Created by Dung Do on 7/29/19.
//  Copyright © 2019 HD. All rights reserved.
//

import Foundation

struct FileHelper {
    
    private init() {}
    
    static func getDirectory(path: FileManager.SearchPathDirectory) -> URL {
        return try! FileManager.default.url(for: path, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    static func checkExists(url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    static func getFileInformation(url: URL) -> [FileAttributeKey: Any]? {
//        All attribute keys:
//        appendOnly
//        busy
//        creationDate
//        deviceIdentifier
//        extensionHidden
//        groupOwnerAccountID
//        groupOwnerAccountName
//        hfsCreatorCode
//        hfsTypeCode
//        immutable
//        modificationDate
//        ownerAccountID
//        ownerAccountName
//        posixPermissions
//        protectionKey
//        referenceCount
//        size
//        systemFileNumber
//        systemFreeNodes
//        systemFreeSize
//        systemNodes
//        systemNumber
//        systemSize
//        type
        
        return try? FileManager.default.attributesOfItem(atPath: url.path)
    }
    
    static func createFolder(at url: URL) {
        if !FileHelper.checkExists(url: url) {
            try! FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    static func remove(at url: URL) {
        if FileHelper.checkExists(url: url) {
            try! FileManager.default.removeItem(at: url)
        }
    }
    
    static func copy(at url: URL, to disURL: URL) {
        if !FileHelper.checkExists(url: url) {
            return
        }
        
        if FileHelper.checkExists(url: disURL) {
            FileHelper.remove(at: disURL)
        }
        
        try! FileManager.default.copyItem(at: url, to: disURL)
    }
    
    static func move(at url: URL, to disURL: URL) {
        if !FileHelper.checkExists(url: url) {
            return
        }
        
        if FileHelper.checkExists(url: disURL) {
            FileHelper.remove(at: disURL)
        }
        
        try! FileManager.default.moveItem(at: url, to: disURL)
    }
    
    static func writeFile(to url: URL, content: String) {
        if !FileHelper.checkExists(url: url) {
            FileHelper.createFolder(at: url.deletingLastPathComponent())
        }
        
        try! content.write(to: url, atomically: true, encoding: .utf8)
    }
    
    static func readFile(to url: URL) -> String? {
        return try? String(contentsOf: url, encoding: .utf8)
    }
    
}
