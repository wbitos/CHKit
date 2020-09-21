//
//  HexColor.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/14.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import DynamicColor

public protocol HexColor {

}

public extension HexColor where Self : UIColor {
    static func hex(uInt64: UInt64) -> UIColor {
        return DynamicColor(hex: uInt64)
    }
    
    static func hex(uInt64: UInt64, useAlpha: Bool) -> UIColor {
        return DynamicColor(hex: uInt64, useAlpha: useAlpha)
    }
    
    static func hex(string: String) -> UIColor {
        return DynamicColor(hexString: string)
    }
}
