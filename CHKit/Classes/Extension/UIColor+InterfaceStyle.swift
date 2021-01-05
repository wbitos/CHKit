//
//  UIColor+InterfaceStyle.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/21.
//

import UIKit

public extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor.dynamicColor(unspecified: light, light: light, dark: dark)
    }
    
    static func dynamicColor(unspecified: UIColor, light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                }
                if traitCollection.userInterfaceStyle == .light {
                    return light
                }
                return unspecified
            }
        }
        return unspecified
    }
    
    static func dynamicColor(light: UInt64, dark: UInt64) -> UIColor {
        return UIColor.dynamicColor(light: UIColor(hex: light), dark: UIColor(hex: dark))
    }
}
