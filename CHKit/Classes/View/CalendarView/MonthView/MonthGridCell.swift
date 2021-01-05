//
//  MonthGridCell.swift
//  Coco
//
//  Created by suyu on 2019/8/28.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
open class MonthGridCell: CHCollectionViewCell {
    open lazy var gridView: MonthGridView = { () -> MonthGridView in
        let gridViwe = MonthGridView(frame: .zero)
        return gridViwe
    }()
    
    open override func prepare() {
        self.contentView.backgroundColor = .clear

        self.addSubview(self.gridView)
        self.gridView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
}
