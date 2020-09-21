//
//  Database.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/12.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import FMDB

open class Database: NSObject {
    
    public init(name: String) {
        super.init()
        self.name = name
        _ = self.connect()
    }
    
    open var table:String? = nil
    open var name:String = "default.sqlite3"
    open var connection: FMDatabaseQueue? = nil
    open var query: DBQuery = DBQuery()
    
    open func connect() -> Self {
        if let dbPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.chihuahua.fanli")?.appendingPathComponent(self.name).path {
            self.connection = FMDatabaseQueue(path: dbPath)
//            if FileManager.default.fileExists(atPath: dbPath) {
//            }
        }
        return self
    }
    
    open func table(_ name: String) -> Self {
        self.table = name
        return self
    }
    
    open func whereIn(key: String, values: [Any]) -> Self {
        return self
    }
    
    open func whereEqual(key: String, value: Any) -> Self {
        return self
    }
    
    open func whereGreater(key: String, value: Any) -> Self {
        return self
    }
    
    open func whereLesser(key: String, value: Any) -> Self {
        return self
    }
    
    open func whereQuery(query: ((DBQuery) -> Void)) -> Self {
        return self
    }
    
    open func get<T>() -> [T] {
        return []
    }
    
    open func get<T>(columbs: [String]) -> [T] {
        return []
    }
    
    open func first<T>() -> T? {
        return nil
    }
    
//    func save() -> Bool {
//        return true
//    }
}
