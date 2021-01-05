//
//  CHContentCollectionCell.swift
//  CHKit
//
//  Created by 王义平 on 2020/11/19.
//

import UIKit

open class CHContentCollectionCell<T: UIView>: CHCollectionViewCell {
    open var innerView: T = T(frame: .zero)
    
    open override func prepare() {
        self.contentView.addSubview(self.innerView)
        self.innerView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
