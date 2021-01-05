//
//  User.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/29.
//

import UIKit
import ObjectMapper

open class User: CHModel {
    open var nick: String?
    open var avatar: String?

    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
        id = (try? map.value("userid")) ?? 0
        nick = try? map.value("nick")
        avatar = try? map.value("header")
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["userid"]
        nick <- map["nick"]
        avatar <- map["header"]
    }
}
