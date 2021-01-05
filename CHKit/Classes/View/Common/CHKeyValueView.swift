//
//  CHKeyValueView.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/24.
//

import UIKit

open class CHKeyValueView: CHView {
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepare()
    }

    public override init() {
        super.init(frame: .zero)
        self.prepare()
    }
    
    open override func prepare() {
        
    }
}
