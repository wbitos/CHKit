//
//  CHIconLabelView.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/14.
//

import UIKit

open class CHIconLabelView: CHView {
    open lazy var iconView: UIImageView = { () -> UIImageView in
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    open lazy var label: UILabel = { () -> UILabel in
        let label = UILabel(frame: .zero)
        return label
    }()
    
    open override func prepare() {
        self.addSubview(self.iconView)
        self.iconView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(0)
            maker.width.equalTo(15)
            maker.height.equalTo(15)
            maker.centerY.equalToSuperview()
        }
        
        self.addSubview(self.label)
        self.label.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.leading.equalTo(strong.iconView.snp.trailing).offset(6)
            maker.trailing.lessThanOrEqualToSuperview().offset(0)
            maker.centerY.equalToSuperview()
        }
    }
}
