//
//  CHShareService.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/29.
//

import UIKit

open class CHShareService: NSObject {
    public static var shared = CHShareService()

    
    open var platforms: [String: CHSharePlatform] = [:]
    
    open func register(platform: CHSharePlatform, with identify: CHSharePlatform.Identify) {
        self.platforms[identify.rawValue] = platform
    }
    
    open func platforms(for identifiers: [CHSharePlatform.Identify]) -> [CHSharePlatform] {
        return identifiers.map { [weak self](identify) -> CHSharePlatform in
            guard let strong = self else {
                return CHSharePlatform()
            }
            return strong.platform(for: identify)
        }
    }
    
    open func platform(for identifier: CHSharePlatform.Identify) -> CHSharePlatform {
        return self.platforms[identifier.rawValue] ?? CHSharePlatform()
    }
    
    open func all() -> [CHSharePlatform] {
        return self.platforms(for: [.system, .wechatFriend, .wechatTimeline])
    }
    
    open func prepare(service: Closures.Action<CHShareService>? = nil) {
        service?(self)
    }
    
    open var fallback: Closures.ActionCallback<(CHSharePlatform, CHShareMedia), Bool>? = nil

}
