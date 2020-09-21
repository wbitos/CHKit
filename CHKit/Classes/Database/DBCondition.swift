//
//  DBCondition.swift
//  chihuahua
//
//  Created by wbitos on 2019/3/2.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

public protocol Queryble {
    
}

extension String: Queryble {
    
}

extension Int: Queryble {
    
}

extension Int64: Queryble {
    
}

extension Date: Queryble {
    
}

extension Bool: Queryble {
    
}



open class DBCondition: NSObject {
    public enum Keys: String {
        case equal = "="
        case greater = ">"
        case lesser = "<"
        case between = "betwwen"
        case `in` = "in"
    }
    
    open var first: Bool = false
    open var or: Bool = false
    open var key: String = ""
    open var condition: DBCondition.Keys = .equal
    open var value: Queryble? = nil
}
