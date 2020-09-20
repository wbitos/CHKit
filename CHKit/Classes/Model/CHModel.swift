//
//  CHModel.swift
//  chihuahua
//
//  Created by 王义平 on 2018/11/15.
//  Copyright © 2018年 wbitos. All rights reserved.
//

import UIKit
import ObjectMapper
import FMDB

enum PropertyTypes: String {
    case Int8 = "c"
    case Int16 = "s"
    case Int32 = "i"
    case Int = "q"
    case UInt16 = "S"
    case UInt32 = "I"
    case UInt = "Q"
    case Bool = "B"
    case Double = "d"
    case Float = "f"
    case Decimal = "{"
}

typealias PropertyType = String

typealias CHModelClass = CHModel.Type

protocol CHModelProtocol {
    
}

protocol CHModelDatabaseProtocol {
    
}

@objcMembers
class CHModel: BaseModel, Mappable, CHModelProtocol {
    var id: Int64 = 0
    var created: Date = Date()
    var modified: Date = Date()
    
    private var db: String = "default.sqlite3"
    private var connection: FMDatabaseQueue? = nil
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        id = (try? map.value("id")) ?? 0
        created = (try? map.value("created")) ?? Date()
        modified = (try? map.value("modified")) ?? Date()
    }
    
    convenience init?(file key: String) {
        let cachePath = CHModel.cachePath(forKey: key)
        
        NSLog("cache path: \(cachePath.path)")
        
        if let jsonString = try? String(contentsOf: cachePath, encoding: .utf8) {
            self.init(JSONString: jsonString)
        }
        else {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        created <- (map["created"], CustomDateFormatTransform(formatString: "yyyy-MM-dd HH:mm:ss"))
        modified <- (map["modified"], CustomDateFormatTransform(formatString: "yyyy-MM-dd HH:mm:ss"))
    }
    
    func database() -> String {
        return self.db
    }
    
    func insert() -> Bool {
        let map = self.toJSON()
        
        let filtered = map.keys.filter { (name) -> Bool in
            return name != "id"
        }
        
        let names = filtered.map { (name) -> String in
            return "`\(name)`"
        }
        let flags = filtered.map { (name) -> String in
            return ":\(name)"
        }
        
        let sql = "insert into \(self.table()) (\(names.joined(separator: ","))) values (\(flags.joined(separator: ",")))"
        
        NSLog("excute: \(sql)")
        
        var isSuccess = false
        self.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: map)
        }
        return isSuccess
    }
    
    func replace() -> Bool {
        let map = self.toJSON()
        
        let names = map.keys.map { (name) -> String in
            return "`\(name)`"
        }
        let flags = map.keys.map { (name) -> String in
            return ":\(name)"
        }
        let sql = "insert or replace into \(self.table()) (\(names.joined(separator: ","))) values (\(flags.joined(separator: ",")))"
        
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: map)
        }
        return isSuccess
    }
    
    func update() -> Bool {
        let map = self.toJSON()
        
        let flags = map.keys.filter { (name) -> Bool in
                return name != "id"
            }.map { (name) -> String in
            return "`\(name)` = :\(name)"
        }
        let sql = "update \(self.table()) set \(flags.joined(separator: ",")) where id=:id"
        
        NSLog("excute: \(sql) values: \(self.toJSONString() ?? "")")
        
        var isSuccess = false
        self.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: map)
        }
        return isSuccess
    }
    
    @discardableResult
    func save() -> Bool {
        return self.id == 0 ? self.insert() : self.replace()
    }
    
    @discardableResult
    class func empty() -> Bool {
        let sql = "delete from \(self.table())"
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: [:])
        }
        return isSuccess
    }
    
    class func `where`(_ key: String, value: Queryble) -> DBQuery {
        return self.where(key, conditionkey: .equal, value: value)
    }
    
    class func `where`(_ key: String, conditionkey: DBCondition.Keys, value: Queryble) -> DBQuery {
        let query = DBQuery()
        query.table = self.table()
        query.connection = self.connect()
        return query.where(key, conditionkey: conditionkey, value: value)
    }
    
    class func skip(_ offset: Int64) -> DBQuery {
        let query = DBQuery()
        query.table = self.table()
        query.connection = self.connect()
        return query.skip(offset)
    }
    
    class func take(_ count: Int64) -> DBQuery {
        let query = DBQuery()
        query.table = self.table()
        query.connection = self.connect()
        return query.take(count)
    }
    
    class func all<T: Mappable>() -> [T] {
        let query = DBQuery()
        query.table = self.table()
        query.connection = self.connect()
        return query.get()
    }
    
    class func latest<T: Mappable>(_ count: Int64) -> [T] {
        let query = DBQuery()
        query.table = self.table()
        query.connection = self.connect()
        return query.orderby("updated_at", sequence: .desc).take(count).get()
    }
    
    class func latest<T: Mappable>() -> T? {
        let query = DBQuery()
        query.table = self.table()
        query.connection = self.connect()
        return query.orderby("updated_at", sequence: .desc).take(1).get().first
    }
    
    func insert(db: FMDatabase) -> Bool {
        let map = self.toJSON()
        
        let filtered = map.keys.filter { (name) -> Bool in
            return name != "id"
        }
        
        let names = filtered.map { (name) -> String in
            return "`\(name)`"
        }
        let flags = filtered.map { (name) -> String in
            return ":\(name)"
        }
        
        let sql = "insert into \(self.table()) (\(names.joined(separator: ","))) values (\(flags.joined(separator: ",")))"
        
        NSLog("excute: \(sql)")
        let isSuccess = db.executeUpdate(sql, withParameterDictionary: map)
        return isSuccess
    }
    
    func replace(db: FMDatabase) -> Bool {
        let map = self.toJSON()
        
        let names = map.keys.map { (name) -> String in
            return "`\(name)`"
        }
        let flags = map.keys.map { (name) -> String in
            return ":\(name)"
        }
        let sql = "insert or replace into \(self.table()) (\(names.joined(separator: ","))) values (\(flags.joined(separator: ",")))"
        
        NSLog("excute: \(sql)")
        let isSuccess = db.executeUpdate(sql, withParameterDictionary: map)
        return isSuccess
    }
    
    func update(db: FMDatabase) -> Bool {
        let map = self.toJSON()
        
        let flags = map.keys.filter { (name) -> Bool in
            return name != "id"
            }.map { (name) -> String in
                return "`\(name)` = :\(name)"
        }
        let sql = "update \(self.table()) set \(flags.joined(separator: ",")) where id=:id"
        
        NSLog("excute: \(sql) values: \(self.toJSONString() ?? "")")
        
        let isSuccess = db.executeUpdate(sql, withParameterDictionary: map)
        return isSuccess
    }
    
    func save(db: FMDatabase) -> Bool {
        return self.id == 0 ? self.insert(db: db) : self.replace(db: db)
    }
    
    func inDatabase(_ block: ((FMDatabase) -> Void)) {
        self.connect()?.inDatabase(block)
    }
    
    func inTransaction(_ block: ((FMDatabase, UnsafeMutablePointer<ObjCBool>) -> Void)) {
        self.connect()?.inTransaction(block)
    }
    
    class func inDatabase(_ block: ((FMDatabase) -> Void)) {
        let aType: CHModel.Type = self
        let model = aType.init(JSON: [:])
        model?.connect()?.inDatabase(block)
    }
    
    class func inTransaction(_ block: ((FMDatabase, UnsafeMutablePointer<ObjCBool>) -> Void)) {
        let aType: CHModel.Type = self
        let model = aType.init(JSON: [:])
        model?.connect()?.inTransaction(block)
    }
    
    func table() -> String {
        return String(describing: self.classForCoder)
    }
    
    class func table() -> String {
        return String(describing: self.classForCoder())
    }
    
    class func connect() -> FMDatabaseQueue? {
        let aType: CHModel.Type = self
        let model = aType.init(JSON: [:])
        return model?.connect()
    }
    
    func connect() -> FMDatabaseQueue? {
        if let connection = self.connection {
            return connection
        }
        if let dbDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.chihuahua.fanli")?.appendingPathComponent("Databases").path {
            if !FileManager.default.fileExists(atPath: dbDir) {
                try? FileManager.default.createDirectory(atPath: dbDir, withIntermediateDirectories: true, attributes: nil)
            }
            
            NSLog("db path: \(dbDir)")
            
            let dbPath = URL(fileURLWithPath: dbDir).appendingPathComponent(self.db).path
            self.connection = FMDatabaseQueue(path: dbPath)
            return self.connection
        }
        
        let documentPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!)
        let dbDir = documentPath.appendingPathComponent("Databases").path
        if !FileManager.default.fileExists(atPath: dbDir) {
            try? FileManager.default.createDirectory(atPath: dbDir, withIntermediateDirectories: true, attributes: nil)
        }
        let dbPath = URL(fileURLWithPath: dbDir).appendingPathComponent(self.db).path
        let connection = FMDatabaseQueue(path: dbPath)
        self.connection = connection
        return connection
    }
    
    func columbs() -> [String] {
        return self.properties(true)
    }
    
    class func columbs() -> [String] {
        return self.properties(true)
    }
    
    func properties(_ deep: Bool) -> [PropertyType] {
        return CHModel.properties(forClass: self.classForCoder, deep: deep)
    }
    
    class func properties(forClass aClass: AnyClass, deep: Bool) -> [PropertyType] {
        var properties:[String] = []
        var cls: AnyClass = aClass
        repeat {
            var count: UInt32 = 0
            if let list = class_copyPropertyList(cls, &count) {
                for i in 0..<count {
                    let cname = property_getName(list[Int(i)])
                    if let name = String(cString: cname, encoding: String.Encoding.utf8) {
                        properties.append(name)
                    }
                }
                free(list)
            }
            if let su = cls.superclass() {
                cls = su
                if cls == NSObject.classForCoder() {
                    break
                }
            }
            else {
                break
            }
        } while(deep)
        return properties
    }
    
    class func properties(_ deep: Bool) -> [PropertyType] {
        return CHModel.properties(forClass: self.classForCoder(), deep: deep)
    }
    
    class func migrate() -> Bool {
        let aType: CHModel.Type = self
        let model = aType.init(JSON: [:])
        let sql = self.migration()
        let tableName = self.table()
        
        NSLog("found migration:\(sql)")

        model?.inDatabase({ (db) in
            if !db.tableExists(tableName) {
                do {
                    try db.executeUpdate(sql, values: nil)
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        })
        return true
    }
    
    class func migration() -> String {
        let columbs = self.columbs().filter { (name) -> Bool in
            return name != "id"
        }.map { (name) -> String in
            return "`\(name)`"
        }
        let table = self.table()
        let sql = "create table \(table) (id integer primary key autoincrement not null, \(columbs.joined(separator: ",")))"
        return sql
    }
//    static func table() -> String {
//        return String(NSStringFromClass(self).split(separator: ".").last ?? "")
//    }
}

extension Array where Element: CHModel {
    func save() {
        
        for model in self {
            _ = model.save()
        }
        
    }
    
    func save(db: FMDatabase) {
        
        for model in self {
            _ = model.save(db: db)
        }
        
    }
    
    init?(file key: String) {
        let cachePath = CHModel.cachePath(forKey: key)
        if let jsonString = try? String(contentsOf: cachePath, encoding: .utf8) {
            self.init(JSONString: jsonString)
        }
        else {
            return nil
        }
    }
}
