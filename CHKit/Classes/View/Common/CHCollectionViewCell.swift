//
//  CHCollectionViewCell.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/14.
//

import UIKit

open class CHCollectionViewCell: UICollectionViewCell {
    init() {
        super.init(frame: .zero)
        self.prepare()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepare()
    }
    
    open func prepare() {

    }
}
