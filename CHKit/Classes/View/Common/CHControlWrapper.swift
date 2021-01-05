//
//  CHControlWrapper.swift
//  CHKit
//
//  Created by 王义平 on 2020/11/22.
//

import UIKit

open class CHControlWrapper<T: UIView>: CHControl {
    open var contentView: T = T(frame: .zero)
    
    open override func prepare() {
        self.contentView.isUserInteractionEnabled = false
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
