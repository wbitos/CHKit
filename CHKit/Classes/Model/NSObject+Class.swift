//
//  NSObject+Class.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/28.
//

import UIKit

public protocol ClassName {
    
}

extension ClassName where Self: NSObject {
    public static func className() -> String {
        return NSStringFromClass(self.classForCoder())
    }
}

