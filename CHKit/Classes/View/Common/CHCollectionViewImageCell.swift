//
//  CHCollectionViewImageCell.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/22.
//

import UIKit

open class CHCollectionViewImageCell: UICollectionViewCell {
    open var imageView: UIImageView = UIImageView(frame: .zero)
    
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
        self.imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
