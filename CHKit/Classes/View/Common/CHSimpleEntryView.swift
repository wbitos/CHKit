//
//  CHSimpleEntryView.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/2.
//

import UIKit

open class CHSimpleEntryView: CHControl {
    open lazy var nameLabel: UILabel = { () -> UILabel in
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    open lazy var indicatorView: UIImageView = { () -> UIImageView in
        let imageView = UIImageView(frame: .zero)
        imageView.image = CHBundle.shared.image(named: "entry_indicator")
        return imageView
    }()
    
    open lazy var seperator: PhysicalOnePixelSeperatorVertical = { () -> PhysicalOnePixelSeperatorVertical in
        let seperator = PhysicalOnePixelSeperatorVertical(frame: .zero)
        seperator.backgroundColor = UIColor.dynamicColor(light: 0xf8f8f8, dark: 0xf8f8f8)
        return seperator
    }()
    
    open override func prepare() {
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.centerY.equalToSuperview()
        }
        
        self.addSubview(self.indicatorView)
        self.indicatorView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
//            maker.leading.equalTo(strong.nameLabel.snp.trailing)
            maker.trailing.equalToSuperview().offset(-20)
            maker.centerY.equalToSuperview()
        }
        
        self.addSubview(self.seperator)
        self.seperator.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1.0/UIScreen.main.scale)
        }
    }
}
