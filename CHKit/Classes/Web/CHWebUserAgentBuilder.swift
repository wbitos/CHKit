//
//  CHWebUserAgentBuilder.swift
//  CHKit
//
//  Created by 王义平 on 2020/11/19.
//

import UIKit
import WebKit

open class CHWebUserAgentBuilder: NSObject {
    public static var shared = CHWebUserAgentBuilder()
    open var customUserAgent: String? = nil

    static var wkwebview = WKWebView(frame: .zero)

    open func installWebviewUserAgent(_ complete: Closures.Action<String>?) {
        CHWebUserAgentBuilder.wkwebview.evaluateJavaScript("navigator.userAgent") { (response, error) in
            guard let userAgent = response as? String else {
                let userAgent = SharedConfig.shared.userAgent()
                self.customUserAgent = userAgent
                complete?(userAgent)
                return
            }
            complete?(self.rebuildUserAgent(userAgent))
        }
    }
    
    open func rebuildUserAgent(_ origin: String) -> String {
        let userDefaults = UserDefaults.standard
        guard let range = origin.range(of: "|") else {
            let userAgent = "\(origin)|\(SharedConfig.shared.userAgent())"
            userDefaults.register(defaults: ["UserAgent": userAgent])
            self.customUserAgent = userAgent
            return userAgent
        }
        
        let userAgent = "\(origin.prefix(upTo: range.lowerBound))|\(SharedConfig.shared.userAgent())"
        userDefaults.register(defaults: ["UserAgent": userAgent])
        self.customUserAgent = userAgent
        return userAgent
    }
}
