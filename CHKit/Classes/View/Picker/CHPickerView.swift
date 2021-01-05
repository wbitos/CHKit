//
//  CHPickerView.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/24.
//

import UIKit

open class CHPickerView: UIView {
    open class HeaderView: UIView {
        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.prepare()
        }
        
        required public init?(coder: NSCoder) {
            super.init(coder: coder)
            self.prepare()
        }
        
        public init() {
            super.init(frame: .zero)
            self.prepare()
        }
        
        open func prepare() {
        }
    }
    
    open class FooterView: UIView {
        open lazy var confirmButton: UIButton = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.setTitle("确定", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            button.setTitleColor(UIColor.dynamicColor(light: 0x689a32, dark: 0x689a32), for: .normal)
            return button
        }()
        
        open lazy var cancelButton: UIButton = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.setTitle("取消", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            button.setTitleColor(UIColor.dynamicColor(light: .black, dark: .black), for: .normal)
            return button
        }()
        
        open lazy var seperator: CHView = { () -> CHView in
            let view = CHView(frame: .zero)
            view.backgroundColor = UIColor.dynamicColor(light: 0xf1f1f1, dark: 0xf1f1f1)
            return view
        }()
        
        open lazy var seperator2: CHView = { () -> CHView in
            let view = CHView(frame: .zero)
            view.backgroundColor = UIColor.dynamicColor(light: 0xf1f1f1, dark: 0xf1f1f1)
            return view
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.prepare()
        }
        
        required public init?(coder: NSCoder) {
            super.init(coder: coder)
            self.prepare()
        }
        
        public init() {
            super.init(frame: .zero)
            self.prepare()
        }
        
        open func prepare() {
            self.addSubview(self.seperator)
            self.seperator.snp.makeConstraints { (maker) in
                maker.leading.equalToSuperview()
                maker.top.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.height.equalTo(1.0/UIScreen.main.scale)
            }
            
            self.addSubview(self.cancelButton)
            self.cancelButton.snp.makeConstraints { (maker) in
                maker.leading.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
            }
            
            self.addSubview(self.confirmButton)
            self.confirmButton.snp.makeConstraints { [weak self](maker) in
                guard let strong = self else {
                    return
                }
                maker.leading.equalTo(strong.cancelButton.snp.trailing)
                maker.trailing.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.width.equalTo(strong.cancelButton.snp.width)
            }
            
            self.addSubview(self.seperator2)
            self.seperator2.snp.makeConstraints { (maker) in
                maker.centerX.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.width.equalTo(1.0/UIScreen.main.scale)
            }
        }
    }
}
