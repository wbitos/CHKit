//
//  Entry.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/4.
//

import UIKit
import ObjectMapper

open class Entry: CHModel {
    open var imageUrl: String?
    open var title: String?
    open var desc: String?
    open var url: String?
    open var action: Closures.Action<Entry>?
    open var badge: String? = nil
    open var height: Int = 0
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
        imageUrl = try? map.value("imageUrl")
        title = try? map.value("title")
        desc = try? map.value("desc")
        url = try? map.value("url")
        action = try? map.value("action")
        badge = try? map.value("badge")
        height = (try? map.value("height")) ?? 0
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        imageUrl <- map["imageUrl"]
        title <- map["title"]
        desc <- map["desc"]
        url <- map["url"]
        action <- map["action"]
        badge <- map["badge"]
        height <- map["height"]
    }
}
