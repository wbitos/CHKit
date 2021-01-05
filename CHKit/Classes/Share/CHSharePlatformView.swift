//
//  CHSharePlatformView.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/29.
//

import UIKit

open class CHSharePlatformView: CHControl {
    open lazy var iconView: UIImageView = { () -> UIImageView in
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    open lazy var nameLabel: UILabel = { () -> UILabel in
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.dynamicColor(light: 0x686868, dark: 0x686868)
        return label
    }()
    
    open var platform: CHSharePlatform? = nil {
        didSet {
            guard let platform = self.platform else {
                return
            }
            
            self.iconView.image = platform.icon
            self.nameLabel.text = platform.name
        }
    }
    
    open override func prepare() {
        self.addSubview(self.iconView)
        self.iconView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.top.equalTo(strong.iconView.snp.bottom).offset(10)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
    }
}
