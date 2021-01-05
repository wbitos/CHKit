//
//  CHShareSheetView.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/29.
//

import UIKit

open class CHShareSheetView: CHView {
    open class ContentView: CHView {
        
    }
    
    open class FooterView: CHView {
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
        
        open override func prepare() {
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
                maker.trailing.equalToSuperview()
            }
        }
    }
    
    open lazy var contentView: ContentView = { () -> ContentView in
        let contentView = ContentView(frame: .zero)
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    open lazy var footerView: FooterView = { () -> FooterView in
        let footerView = FooterView(frame: .zero)
        footerView.backgroundColor = .clear
        return footerView
    }()
    
    open var platformViews: [CHSharePlatformView] = [] {
        didSet {
            for v in self.contentView.subviews {
                v.removeFromSuperview()
            }
            
            if self.platformViews.count == 0 {
                return
            }
            
            if self.platformViews.count == 1 {
                let view = self.platformViews[0]
                self.contentView.addSubview(view)
                view.snp.makeConstraints { (maker) in
                    maker.leading.equalToSuperview().offset(15)
                    maker.trailing.equalToSuperview().offset(-15)
                    maker.centerY.equalToSuperview()
                }
                return
            }
            
            var prev: CHSharePlatformView? = nil
            for i in 0..<self.platformViews.count {
                let view = self.platformViews[i]
                self.contentView.addSubview(view)
                let last = i == self.platformViews.count - 1
                if let l = prev {
                    
                    view.snp.makeConstraints { (maker) in
                        maker.leading.equalTo(l.snp.trailing)
                        maker.centerY.equalToSuperview()
                        maker.width.equalTo(l.snp.width)
                        if last {
                            maker.trailing.equalToSuperview().offset(-15)
                        }
                    }
                    
                }
                else {
                    view.snp.makeConstraints { (maker) in
                        maker.leading.equalToSuperview().offset(15)
                        maker.centerY.equalToSuperview()
                    }
                }
                
                prev = view
            }
        }
    }
    
    open override func prepare() {
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
//            maker.height.equalTo(140)
        }
        
        self.addSubview(self.footerView)
        self.footerView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(strong.contentView.snp.bottom)
            maker.height.equalTo(50)
            maker.bottom.equalToSuperview()
        }
    }
}
