//
//  IntegerTransform.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/22.
//

import UIKit
import ObjectMapper

open class IntegerTransform: TransformType {
    public typealias Object = Int
    public typealias JSON = Any?
    
    public init() {
        
    }
    
    public func transformFromJSON(_ value: Any?) -> Int? {
        var result: Int? = nil
        
        if let strValue = value as? String {
            result = Int(strValue)
        }
        else if let intValue = value as? Int {
            result = intValue
        }
        return result
    }
    
    public func transformToJSON(_ value: Int?) -> Any?? {
        return value
    }
}
