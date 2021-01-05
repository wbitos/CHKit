//
//  Pagination.swift
//  CHKit
//
//  Created by 王义平 on 2020/11/19.
//

import UIKit
import ObjectMapper

open class Pagination<T: CHModel>: CHModel {
    open var list: [T] = []
    open var current: Int = 0
    open var total: Int = 0
    open var pageSize: Int = 0
    open var more: Bool = false
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
        list = (try? map.value("list")) ?? []
        current = (try? map.value("current")) ?? 0
        total = (try? map.value("total")) ?? 0
        pageSize = (try? map.value("pageSize")) ?? 0
        more = (try? map.value("more")) ?? false
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        list <- map["list"]
        current <- map["current"]
        total <- map["total"]
        pageSize <- map["pageSize"]
        more <- map["more"]
    }
}
