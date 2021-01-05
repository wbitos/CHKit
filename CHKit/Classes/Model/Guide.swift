//
//  Guide.swift
//  CHKit
//
//  Created by 王义平 on 2020/11/19.
//

import UIKit
import ObjectMapper

open class Guide: CHModel {
    open var image: String? = nil
    open var title: String? = nil
    open var desc: String? = nil
    open var action: String? = nil
    open var skip: String? = nil

    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
        image = try? map.value("image")
        title = try? map.value("title")
        desc = try? map.value("desc")
        action = try? map.value("action")
        skip = try? map.value("skip")
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        image <- map["image"]
        title <- map["title"]
        desc <- map["desc"]
        action <- map["action"]
        skip <- map["skip"]
    }
}
