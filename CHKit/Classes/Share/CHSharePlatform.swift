//
//  CHSharePlatform.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/29.
//

import UIKit

open class CHSharePlatform: NSObject {
    public enum Identify: String {
        case wechatFriend = "friends"
        case wechatTimeline = "timeline"
        case system = "saveLocal"
    }
    
    open var name: String = ""
    open var icon: UIImage = UIImage()

    open var action: Closures.ActionCallback<CHShareMedia, Bool>? = nil
    
    open func share(media: CHShareMedia, complete: Closures.Action<Bool>? = nil) {
        self.action?(media, complete)
    }
    
}
