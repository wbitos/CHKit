//
//  CHCollectionViewImageTitleCell.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/25.
//

import UIKit

open class CHCollectionViewImageTitleCell: UICollectionViewCell {
    open lazy var imageView: UIImageView = { () -> UIImageView in
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    open lazy var titleLabel: UILabel = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = UIColor.dynamicColor(light: 0xaba29b, dark: 0xaba29b)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.prepare()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepare()
    }
    
    open func prepare() {
        self.imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-20)
        }
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.centerX.equalToSuperview()
            maker.top.equalTo(strong.imageView.snp.bottom).offset(6)
        }
    }
}
