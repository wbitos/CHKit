//
//  TimeAxisCell.swift
//  Coco
//
//  Created by wbitos on 2019/8/29.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit

open class TimeAxisCell<T: UIView>: UICollectionViewCell {
    open var itemView: T = T(frame: .zero)
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepare()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    public func prepare() {
        self.contentView.addSubview(self.itemView)
        self.itemView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func setup() {
        
    }
}
