//
//  CHKitNotifications.swift
//  CHKit
//
//  Created by 王义平 on 2020/12/29.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

public enum CHKitNotifications: String {
    case userSignIn = "user.signin"
    case userSignout = "user.signout"
    case userCertified = "user.certified"

    case webviewReload = "webview.reload"

    public func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(self.rawValue), object: object, userInfo: userInfo)
        }
    }
    
    public func signal() -> Signal<Notification, Never> {
        return NotificationCenter.default.reactive.notifications(forName: NSNotification.Name(self.rawValue))
    }
}
