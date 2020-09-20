//
//  DeviceConfig.swift
//  chihuahua
//
//  Created by 王义平 on 2018/11/16.
//  Copyright © 2018年 wbitos. All rights reserved.
//

import UIKit

class DeviceConfig: NSObject {
    static var Appkey = "83f5a1d7-7678-4dcf-8cb5-433cfccf6e27"
    static var Secret = "wGl2rvlP6vQE5n3G48KfDoUtjHvw9tUWL3LfSbiNTq1MpXh1"
    
    static func document() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? NSHomeDirectory() + "/Documents"
    }
    
    static func cache() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? NSHomeDirectory() + "/Library/Caches"
    }
    
    static func cache(domain: String) -> String {
        let url = URL(fileURLWithPath: self.cache()).appendingPathComponent(domain)
        return url.path
    }
    
    static func cachePath(forKey key: String, domain: String = "com.overnight.blueeyed") -> URL {
        let cacheDir = URL(fileURLWithPath: DeviceConfig.cache(domain: domain))
        let filemanager = FileManager.default
        if !filemanager.fileExists(atPath: cacheDir.path) {
            do {
                try filemanager.createDirectory(atPath: cacheDir.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("\(error)")
            }
        }
        let cachePath = cacheDir.appendingPathComponent(key)
        return cachePath
    }
    
    static func document(with component: String) -> String {
        return self.documentUrl().appendingPathComponent(component).path
    }
    
    static func documentUrl() -> URL {
        return URL(fileURLWithPath: self.document())
    }    
}
