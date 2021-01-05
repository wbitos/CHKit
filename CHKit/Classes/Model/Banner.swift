//
//  Banner.swift
//  blueeyed
//
//  Created by wbitos on 2019/12/5.
//  Copyright © 2019 Overnight. All rights reserved.
//

import UIKit
import ObjectMapper

open class Banner: CHModel {
    open var imageName: String?
    open var imageUrl: String?
    open var title: String?
    open var sequence: Int = 0
    open var status: Int = 0
    open var url: String?
    open var action: Closures.Action<Banner>?

    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
        imageName = try? map.value("imageName")
        imageUrl = try? map.value("bannerImage")
        title = try? map.value("title")
        sequence = (try? map.value("sequence")) ?? 0
        status = (try? map.value("status")) ?? 0
        url = try? map.value("redirectUrl")
        action = try? map.value("action")
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        imageName <- map["imageName"]
        imageUrl <- map["bannerImage"]
        title <- map["title"]
        sequence <- map["sequence"]
        status <- map["status"]
        url <- map["redirectUrl"]
        action <- map["action"]
    }
}
