//
//  DBCondition.swift
//  chihuahua
//
//  Created by wbitos on 2019/3/2.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

protocol Queryble {
    
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



class DBCondition: NSObject {
    enum Keys: String {
    case equal = "="
    case greater = ">"
    case lesser = "<"
    case between = "betwwen"
    case `in` = "in"
    }
    
    var first: Bool = false
    var or: Bool = false
    var key: String = ""
    var condition: DBCondition.Keys = .equal
    var value: Queryble? = nil
}
