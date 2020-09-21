//
//  SharedConfig.swift
//  blueeyed
//
//  Created by wbitos on 2019/11/26.
//  Copyright © 2019 Overnight. All rights reserved.
//

import UIKit

open class SharedConfig: NSObject {
    @objc static let shared = SharedConfig()

    public var app = AppConfig()
    public var sys = SysConfig()
}
