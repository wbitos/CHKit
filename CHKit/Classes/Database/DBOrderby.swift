//
//  DBOrderby.swift
//  chihuahua
//
//  Created by wbitos on 2019/3/5.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

class DBOrderby: NSObject {
    enum Sequence: String {
        case asc = "asc"
        case desc = "desc"
    }
    
    var by: String = ""
    var sequence: DBOrderby.Sequence = DBOrderby.Sequence.asc
}
