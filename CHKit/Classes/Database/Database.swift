//
//  Database.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/12.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import FMDB

class Database: NSObject {
    
    init(name: String) {
        super.init()
        self.name = name
        _ = self.connect()
    }
    
    var table:String? = nil
    var name:String = "default.sqlite3"
    var connection: FMDatabaseQueue? = nil
    var query: DBQuery = DBQuery()
    
    func connect() -> Self {
        if let dbPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.chihuahua.fanli")?.appendingPathComponent(self.name).path {
            self.connection = FMDatabaseQueue(path: dbPath)
//            if FileManager.default.fileExists(atPath: dbPath) {
//            }
        }
        return self
    }
    
    func table(_ name: String) -> Self {
        self.table = name
        return self
    }
    
    func whereIn(key: String, values: [Any]) -> Self {
        return self
    }
    
    func whereEqual(key: String, value: Any) -> Self {
        return self
    }
    
    func whereGreater(key: String, value: Any) -> Self {
        return self
    }
    
    func whereLesser(key: String, value: Any) -> Self {
        return self
    }
    
    func whereQuery(query: ((DBQuery) -> Void)) -> Self {
        return self
    }
    
    func get<T>() -> [T] {
        return []
    }
    
    func get<T>(columbs: [String]) -> [T] {
        return []
    }
    
    func first<T>() -> T? {
        return nil
    }
    
//    func save() -> Bool {
//        return true
//    }
}
