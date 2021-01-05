//
//  CHBorderedLabel.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/23.
//

import UIKit

open class CHBorderedLabel: UIView {
    public var label: UILabel = { () -> UILabel in
        let label = UILabel()
        return label
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
        self.addSubview(self.label)
        self.label.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.top.equalToSuperview().offset(4)
            maker.bottom.equalToSuperview().offset(-4)
        }
    }
}
