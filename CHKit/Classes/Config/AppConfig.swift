//
//  AppConfig.swift
//  chihuahua
//
//  Created by wbitos on 2019/5/31.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import FCUUID

class AppConfig: NSObject {
    enum Channel: String {
        case appStore = "App Store"
        case development = "Test"
    }
    
    #if DEBUG
    var channel: String = AppConfig.Channel.development.rawValue
    #else
    var channel: String = AppConfig.Channel.appStore.rawValue
    #endif
    
    func name() -> String {
        return (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? "吉娃娃"
    }
    
    func version() -> String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
    }
    
    func build() -> Int {
        return Int((Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "0") ?? 0
    }
    
    func udid() -> String {
        return FCUUID.uuidForDevice() ?? ""
    }
    
    func bundleIdentify() -> String {
        return (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String) ?? "com.overnight.blueeyed"
    }
    
    static func synced(_ lock: Any, closure: Closures.Default<Any>) -> Any {
        objc_sync_enter(lock)
        let ret = closure()
        objc_sync_exit(lock)
        return ret
    }
    
    func cdid() -> String {
        return (AppConfig.synced(self) { () -> Any in
            let defaults = UserDefaults.standard
            guard let deviceId = defaults.string(forKey: "kSignInDeviceId") else {
                if let uuid = FCUUID.uuid() {
                    defaults.set(uuid, forKey: "kSignInDeviceId")
                    defaults.synchronize()
                    return uuid
                }
                return self.udid()
            }
            return deviceId
        } as? String) ?? self.udid()
    }
    
    func uid() -> String {
        return UserDefaults.standard.string(forKey: "kSignInUid") ?? ""
    }
    
    func set(uid: String) {
        UserDefaults.standard.set(uid, forKey: "kSignInUid")
    }
}

class SysConfig: NSObject {
    func name() -> String {
        return UIDevice.current.systemName
    }
    
    func version() -> String {
        return UIDevice.current.systemVersion
    }
    
    func model() -> String {
        return UIDevice.current.model
    }
}
