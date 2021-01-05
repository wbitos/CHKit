//
//  DeviceConfig.swift
//  chihuahua
//
//  Created by 王义平 on 2018/11/16.
//  Copyright © 2018年 wbitos. All rights reserved.
//

import UIKit

open class DeviceConfig: NSObject {
    static var Appkey = "83f5a1d7-7678-4dcf-8cb5-433cfccf6e27"
    static var Secret = "wGl2rvlP6vQE5n3G48KfDoUtjHvw9tUWL3LfSbiNTq1MpXh1"
    
    public static func document() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? NSHomeDirectory() + "/Documents"
    }
    
    public static func cache() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? NSHomeDirectory() + "/Library/Caches"
    }
    
    public static func cache(domain: String) -> String {
        let url = URL(fileURLWithPath: self.cache()).appendingPathComponent(domain)
        return url.path
    }
    
    public static func cachePath(forKey key: String, domain: String = "com.yilian.chkit") -> URL {
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
    
    public static func document(with component: String) -> String {
        return self.documentUrl().appendingPathComponent(component).path
    }
    
    public static func documentUrl() -> URL {
        return URL(fileURLWithPath: self.document())
    }
    
    public static func cache(value: String, for key: String) {
        let fileUrl = DeviceConfig.cachePath(forKey: key)
        try? value.write(to: fileUrl, atomically: true, encoding: .utf8)
    }
    
    public static func cacheValue(for key: String) -> String? {
        let fileUrl = DeviceConfig.cachePath(forKey: key)
        return try? String(contentsOf: fileUrl, encoding: .utf8)
    }
    
    public static func clear(for key: String) {
        let fileUrl = DeviceConfig.cachePath(forKey: key)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileUrl.path) {
            try? fileManager.removeItem(atPath: fileUrl.path)
        }
    }
}
