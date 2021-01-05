//
//  CHControl.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/2.
//

import UIKit

open class CHControl: UIControl {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepare()
    }

    public init() {
        super.init(frame: .zero)
        self.prepare()
    }
    
    open func prepare() {
        
    }
}
