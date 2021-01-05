//
//  CHCardView.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/1.
//

import UIKit

open class CHCardView: CHView {
    open class HeaderView: CHView {
        open lazy var titleLabel: UILabel = { () -> UILabel in
            let label = UILabel(frame: .zero)
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            return label
        }()
        
        open lazy var actionButton: UIButton = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            return button
        }()
        
        open lazy var seperator: PhysicalOnePixelSeperatorVertical = { () -> PhysicalOnePixelSeperatorVertical in
            let seperator = PhysicalOnePixelSeperatorVertical(frame: .zero)
            seperator.backgroundColor = UIColor.dynamicColor(light: 0xf8f8f8, dark: 0xf8f8f8)
            return seperator
        }()
        
        open override func prepare() {
            self.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints { (maker) in
                maker.leading.equalToSuperview().offset(20)
                maker.trailing.equalToSuperview().offset(-20)
                maker.centerY.equalToSuperview()
            }
            
            self.addSubview(self.actionButton)
            self.actionButton.snp.makeConstraints { (maker) in
                maker.trailing.equalToSuperview().offset(-20)
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.width.greaterThanOrEqualTo(40)
            }
            
            self.addSubview(self.seperator)
            self.seperator.snp.makeConstraints { [weak self](maker) in
                guard let strong = self else {
                    return
                }
                maker.leading.equalToSuperview().offset(20)
                maker.trailing.equalToSuperview().offset(-20)
                maker.bottom.equalToSuperview()
                maker.height.equalTo(1.0/UIScreen.main.scale)
            }
            
        }
    }
    open class FooterView: CHView {
        open override func prepare() {
        }
    }
    
    open lazy var headerView: HeaderView = { () -> HeaderView in
        let headerView = HeaderView(frame: .zero)
        
        return headerView
    }()

    open lazy var contentView: CHView = { () -> CHView in
        let view = CHView(frame: .zero)
        return view
    }()
    
    open lazy var footerView: FooterView = { () -> FooterView in
        let footerView = FooterView(frame: .zero)
        
        return footerView
    }()
    
    open override func prepare() {
        self.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(48)
        }
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.top.equalTo(strong.headerView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        self.addSubview(self.footerView)
        self.footerView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.top.equalTo(strong.contentView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(0)
            maker.bottom.equalToSuperview()
        }
    }
}
