//
//  SharedConfig.swift
//  blueeyed
//
//  Created by wbitos on 2019/11/26.
//  Copyright © 2019 Overnight. All rights reserved.
//

import UIKit

open class SharedConfig: NSObject {
    @objc public static let shared = SharedConfig()

    public var app = AppConfig()
    public var sys = SysConfig()
    
    open func userAgent() -> String {
        return "iOS DaoCal \(self.app.version()) (\(self.app.build()))/\(self.app.channel)/\(self.sys.model()) \(self.sys.version())/\(self.app.cdid())/\(0)"
    }
}
