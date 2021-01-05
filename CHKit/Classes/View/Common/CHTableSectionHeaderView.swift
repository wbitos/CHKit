//
//  CHTableSectionHeaderView.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/26.
//

import UIKit

open class CHTableSectionHeaderView: CHView {
    open var captionLabel: UILabel = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = UIColor.dynamicColor(light: .black, dark: .white)
        return label
    }()

    open override func prepare() {
        self.addSubview(self.captionLabel)
        self.captionLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(22)
            maker.trailing.lessThanOrEqualToSuperview().offset(-22)
            maker.bottom.equalToSuperview()
            maker.top.equalToSuperview()
        }
    }
}
