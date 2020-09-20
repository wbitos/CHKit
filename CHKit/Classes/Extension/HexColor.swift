//
//  HexColor.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/14.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import DynamicColor

protocol HexColor {

}

extension HexColor where Self : UIColor {
    static func hex(uInt32: UInt32) -> UIColor {
        return DynamicColor(hex: uInt32)
    }
    
    static func hex(uInt32: UInt32, useAlpha: Bool) -> UIColor {
        return DynamicColor(hex: uInt32, useAlpha: useAlpha)
    }
    
    static func hex(string: String) -> UIColor {
        return DynamicColor(hexString: string)
    }
}
