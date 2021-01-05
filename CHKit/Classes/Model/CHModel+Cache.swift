//
//  CHModel+Cache.swift
//  chihuahua
//
//  Created by wbitos on 2019/6/7.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

public extension CHModel {
    static func cachePath(forKey key: String) -> URL {
        let cacheDir = URL(fileURLWithPath: DeviceConfig.cache(domain: "com.overnight.blueeyed"))
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
    
    @discardableResult
    func cache(key: String) -> Bool {
        let cachePath = CHModel.cachePath(forKey: key)
        if let jsonString = self.toJSONString() {
            try? jsonString.write(to: cachePath, atomically: true, encoding: .utf8)
        }
        return true
    }
}
