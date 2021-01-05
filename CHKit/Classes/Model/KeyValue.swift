//
//  KeyValue.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/18.
//

import UIKit
import ObjectMapper

open class KeyValue<K, V>: NSObject {
    open var key: K
    open var value: V

    init(key: K, value: V) {
        self.key = key
        self.value = value
        super.init()
    }
}
