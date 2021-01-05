//
//  UINavigationController+Current.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/23.
//

import UIKit

public extension UINavigationController {
    static func current() -> UINavigationController? {
        var window: UIWindow? = nil
        if #available(iOS 13.0, *) {
            window = (UIApplication.shared.connectedScenes.filter({ (scence) -> Bool in
                return scence.activationState == .foregroundActive
            }).map({ (scence) -> UIWindowScene? in
                return scence as? UIWindowScene
            }).compactMap({$0}).first?.delegate as? UIWindowSceneDelegate)?.window ?? nil
        } else {
            window = UIApplication.shared.delegate?.window ?? nil
        }
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            return navigationController
        }
        if let tabbarController = window?.rootViewController as? UITabBarController {
            return tabbarController.selectedViewController as? UINavigationController
        }
        return nil
    }
}
