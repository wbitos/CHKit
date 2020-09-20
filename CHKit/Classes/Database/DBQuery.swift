//
//  DBQuery.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/12.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import FMDB
import ObjectMapper

class DBQuery: NSObject {
    var subquries: [DBQuery] = []
    var conditions: [DBCondition] = []
    var table: String = ""
    var connection: FMDatabaseQueue? = nil
    var limit: DBLimit? = nil
    var orderby: [DBOrderby] = []
    
    func whereIn(key: String, values: [Queryble]) -> Self {
        return self
    }
    
    func whereBetween(key: String, from: Queryble, end: Queryble) -> Self {
        return self
    }
    
    func whereEqual(key: String, value: Queryble) -> Self {
        return self
    }
    
    func whereGreater(key: String, value: Queryble) -> Self {
        return self
    }
    
    func whereLesser(key: String, value: Queryble) -> Self {
        return self
    }
    
    func `where`(_ query: ((DBQuery) -> Void)) -> Self {
        return self
    }
    
    func `where`(_ key: String, value: Queryble) -> Self {
        return self.where(key, conditionkey: .equal, value: value)
    }
    
    func `where`(_ key: String, conditionkey: DBCondition.Keys, value: Queryble) -> Self {
        let condition = DBCondition()
        condition.key = key
        condition.condition = conditionkey
        condition.value = value
        condition.first = (self.conditions.count == 0)
        self.conditions.append(condition)
        return self
    }
    
    func orWhere(_ key: String, conditionkey: DBCondition.Keys, value: Queryble) -> Self {
        let condition = DBCondition()
        condition.or = true
        condition.key = key
        condition.condition = conditionkey
        condition.value = value
        condition.first = (self.conditions.count == 0)
        self.conditions.append(condition)
        return self
    }
    
    func orderby(_ key: String, sequence: DBOrderby.Sequence) -> Self {
        let orderby = DBOrderby()
        orderby.by = key
        orderby.sequence = sequence
        self.orderby.append(orderby)
        return self
    }
    
    func skip(_ offset: Int64) -> Self {
        let limit = self.limit ?? DBLimit()
        limit.offset = offset
        self.limit = limit
        return self
    }
    
    func take(_ count: Int64) -> Self {
        let limit = self.limit ?? DBLimit()
        limit.count = count
        self.limit = limit
        return self
    }
    
    func table(_ name: String) -> Self {
        self.table = table
        return self
    }
    
    func build() -> (String, [AnyHashable: Any]) {
        var `where` = ""
        if self.conditions.count > 0 {
            let conditions = self.conditions.map { (condition) -> String in
                let logic = condition.first ? "" : (condition.or ? "or" : "and")
                
                if condition.condition == .in {
                    return "\(logic) `\(condition.key)` \(condition.condition.rawValue) :\(condition.key)"
                }
                else if condition.condition == .between {
                    return "\(logic) `\(condition.key)` \(condition.condition.rawValue) :\(condition.key)-from and :\(condition.key)-end"
                }
                return "\(logic) `\(condition.key)` \(condition.condition.rawValue) :\(condition.key)"
                }.joined(separator: " ")
            
            `where` = "where \(conditions)"
        }
        
        var orderby = ""
        if self.orderby.count > 0 {
            let conditions = self.orderby.map { (ob) -> String in
                return "`\(ob.by)` \(ob.sequence.rawValue)"
            }.joined(separator: ",")
            
            orderby = "order by \(conditions)"
        }
        
        var limit = ""
        if let dblimit = self.limit {
            limit = "limit \(dblimit.offset),\(dblimit.count)"
        }
        
        let sql = "select * from `\(self.table)` \(`where`) \(orderby) \(limit)"
        var parameters: [String: Queryble] = [:]
        for condition in self.conditions {
            if condition.condition == .in {

            }
            else if condition.condition == .between {

            }
            else {
                if let value = condition.value {
                    parameters[condition.key] = value
                }
            }
        }
        return (sql, parameters)
    }
    
    func get<T: Mappable>() -> [T] {
        var models: [T] = []
        let (sql, parameters) = self.build()
        NSLog("excute \(sql) with parameters: \(parameters)")
        self.connection?.inDatabase({ (db) in
            if let rs = db.executeQuery(sql, withParameterDictionary: parameters) {
                while rs.next() {
                    if let map = rs.resultDictionary as? [String: Any] {
                        if let t = T(JSON: map) {
                            models.append(t)
                        }
                    }
                }
                rs.close()
            }
        })
        return models
    }
    
    func get<T: Mappable>(columbs: [String]) -> [T] {
        return []
    }
    
    func first<T: Mappable>() -> T? {
        var model: T? = nil
        let (sql, parameters) = self.build()
        NSLog("excute \(sql) with parameters: \(parameters)")
        self.connection?.inDatabase({ (db) in
            if let rs = db.executeQuery(sql, withParameterDictionary: parameters) {
                if rs.next() {
                    if let map = rs.resultDictionary as? [String: Any] {
                        if let t = T(JSON: map) {
                            model = t
                        }
                    }
                }
                rs.close()
            }
        })
        return model
    }
}
