//
//  CHShareFooterView.swift
//  CHKit
//
//  Created by 王义平 on 2020/12/28.
//

import UIKit

open class CHShareFooterView: CHView {

    open lazy var logoView: UIImageView = { () -> UIImageView in
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    open lazy var qrCodeView: UIImageView = { () -> UIImageView in
        let imageView = UIImageView(frame: .zero)
        
        return imageView
    }()
    
    open lazy var nameLabel: UILabel = { () -> UILabel in
        let label = UILabel(frame: .zero)
        label.text = "黄道日历"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textColor = UIColor.dynamicColor(light: 0x302b27, dark: 0x302b27)

        return label
    }()
    
    open lazy var codeLabel: UILabel = { () -> UILabel in
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.dynamicColor(light: 0xffffff, dark: 0xffffff)
        label.backgroundColor = UIColor.dynamicColor(light: 0xd7cec6, dark: 0xd7cec6)
        label.text = "邀请码 123456"
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        return label
    }()
    
    open override func prepare() {
        self.addSubview(self.logoView)
        self.logoView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.leading.equalToSuperview().offset(15)
            maker.top.equalToSuperview().offset(15)
            maker.bottom.equalToSuperview().offset(-15)
            maker.width.equalTo(60)
            maker.height.equalTo(60)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.top.equalTo(strong.logoView.snp.top)
            maker.leading.equalTo(strong.logoView.snp.trailing).offset(10)
        }
        
        self.addSubview(self.codeLabel)
        self.codeLabel.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.bottom.equalTo(strong.logoView.snp.bottom)
            maker.leading.equalTo(strong.nameLabel.snp.leading)
            maker.height.equalTo(20)
            maker.width.equalTo(100)
        }
        
        self.addSubview(self.qrCodeView)
        self.qrCodeView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-15)
            maker.height.equalTo(60)
            maker.width.equalTo(60)
        }
    }
}
