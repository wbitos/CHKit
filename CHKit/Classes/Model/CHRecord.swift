//
//  CHRecord.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/22.
//

import UIKit
import ObjectMapper

class CHRecord: CHModel {
    open var created: Date = Date()
    open var modified: Date = Date()
    
    required public init?(map: Map) {
        super.init(map: map)
        created = (try? map.value("created")) ?? Date()
        modified = (try? map.value("modified")) ?? Date()
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        created <- (map["created"], CustomDateFormatTransform(formatString: "yyyy-MM-dd HH:mm:ss"))
        modified <- (map["modified"], CustomDateFormatTransform(formatString: "yyyy-MM-dd HH:mm:ss"))
    }
}
