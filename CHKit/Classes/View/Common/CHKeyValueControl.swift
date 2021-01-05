//
//  CHKeyValueControl.swift
//  CHKit
//
//  Created by 王义平 on 2020/12/11.
//

import UIKit

open class CHKeyValueControl: CHControl {
    open var keyLabel: UILabel = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = UIColor.dynamicColor(light: 0xaba29b, dark: 0xaba29b)
        return label
    }()
    
    open var valueLabel: UILabel = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = UIColor.dynamicColor(light: 0x302b27, dark: 0x302b27)
        return label
    }()
    
    open override func prepare() {
        
    }
}
