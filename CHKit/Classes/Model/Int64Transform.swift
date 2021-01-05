//
//  Int64Transform.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/22.
//

import UIKit
import ObjectMapper

open class Int64Transform: TransformType {
    public typealias Object = Int64
    public typealias JSON = Any?
    
    public init() {
        
    }
    
    public func transformFromJSON(_ value: Any?) -> Int64? {
        var result: Int64? = nil
        
        if let strValue = value as? String {
            result = Int64(strValue)
        }
        else if let intValue = value as? Int64 {
            result = intValue
        }
        else if let intValue = value as? Int {
            result = Int64(intValue)
        }
        return result
    }
    
    public func transformToJSON(_ value: Int64?) -> Any?? {
        return value
    }
}
