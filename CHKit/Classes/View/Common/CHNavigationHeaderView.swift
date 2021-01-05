//
//  CHNavigationHeaderView.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/9.
//

import UIKit

open class CHNavigationHeaderView: CHView {
    open class ContentView: CHView {
        open lazy var titleLabel: UILabel = { () -> UILabel in
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.numberOfLines = 0
            label.textColor = UIColor.dynamicColor(light: .black, dark: .white)
            return label
        }()
        
        open lazy var backButton: UIButton = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.setImage(CHBundle.shared.image(named: "navigation_back_indicator_brown"), for: .normal)
            return button
        }()
        
        open lazy var rightButton: UIButton = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.isHidden = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            button.setTitleColor(UIColor.dynamicColor(light: 0x000000, dark: 0x000000), for: .normal)
            return button
        }()
        
        open override func prepare() {
            self.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
            }
            
            self.addSubview(self.backButton)
            self.backButton.snp.makeConstraints { (maker) in
                maker.leading.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.width.equalTo(51)
            }
            
            self.addSubview(self.rightButton)
            self.rightButton.snp.makeConstraints { (maker) in
                maker.trailing.equalToSuperview().offset(-20)
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.width.equalTo(51)
            }
        }
    }

    open lazy var contentView: ContentView = { () -> ContentView in
        let contentView = ContentView(frame: .zero)
        return contentView
    }()
    
    open var title: String? = nil {
        didSet {
            self.contentView.titleLabel.text = self.title
        }
    }
    
    open override func prepare() {
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(44)
        }

    }
}
