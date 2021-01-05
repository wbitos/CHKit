//
//  CHTableCollectionCell.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/28.
//

import UIKit

open class CHTableCollectionCell: CHTableViewCell {
    open lazy var collectionView: UICollectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    open override func prepare() {
        super.prepare()
//        self.contentView.addSubview(self.collectionView)
//        self.collectionView.snp.makeConstraints { (maker) in
//            maker.leading.equalToSuperview().offset(18)
//            maker.trailing.equalToSuperview().offset(-18)
//            maker.top.equalToSuperview()
//            maker.bottom.equalToSuperview()
//        }
    }
}
