//
//  CHView.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/25.
//

import UIKit

open class CHView: UIView {
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
