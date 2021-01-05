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
    public override init() {
        super.init()
    }
    
    init(dbPath: String) {
        super.init()
        self.connect(dbPath: dbPath)
    }
    
    open var table:String? = nil
    open var connection: FMDatabaseQueue? = nil
    open var query: DBQuery = DBQuery()
    
    @discardableResult
    open func connect(dbPath: String) -> Self {
        self.connection = FMDatabaseQueue(path: dbPath)
        return self
    }
    
//    open func table(_ name: String) -> Self {
//        self.table = name
//        return self
//    }
//    
//    open func whereIn(key: String, values: [Any]) -> Self {
//        return self
//    }
//    
//    open func whereEqual(key: String, value: Any) -> Self {
//        return self
//    }
//    
//    open func whereGreater(key: String, value: Any) -> Self {
//        return self
//    }
//    
//    open func whereLesser(key: String, value: Any) -> Self {
//        return self
//    }
//    
//    open func whereQuery(query: ((DBQuery) -> Void)) -> Self {
//        return self
//    }
//    
//    open func get<T>() -> [T] {
//        return []
//    }
//    
//    open func get<T>(columbs: [String]) -> [T] {
//        return []
//    }
//    
//    open func first<T>() -> T? {
//        return nil
//    }
}
