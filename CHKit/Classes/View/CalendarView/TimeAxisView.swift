//
//  TimeAxisView.swift
//  Coco
//
//  Created by wbitos on 2019/8/29.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit

public enum TimeAxisViewDirection {
    case none
    case forward
    case backward
}

@IBDesignable
open class TimeAxisView<T: UIView>: CalendarView {

    class TimeAxisViewCollectionFlowLayout: UICollectionViewFlowLayout {
        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
    }
    
    fileprivate(set) var needsAdjustingViewFrame = true

    var contentView = UIView()

    open var collectionView: UICollectionView = { () -> UICollectionView in
        let flowLayout = TimeAxisViewCollectionFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    open var selectedDate: Date = Date().addingTimeInterval(-86400)
    
    lazy var indicatorView: MonthGridView = { () -> MonthGridView in
        let view = MonthGridView(frame: .zero)
        view.dateView.dayLabel.textColor = UIColor.dynamicColor(light: 0xffffff, dark: 0xffffff)
        view.dateView.lunarLabel.textColor = UIColor.dynamicColor(light: 0xffffff, dark: 0xffffff)
        view.dateView.dayLabel.text = "1"
        view.dateView.lunarLabel.text = "十七"
        return view
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepare()
    }
    
    func prepare() {
        self.addSubview(self.contentView)
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        

        
        self.contentView.frame = self.bounds
        self.collectionView.isPagingEnabled = true
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
    
        self.collectionView.register(TimeAxisCell<T>.self, forCellWithReuseIdentifier: NSStringFromClass(TimeAxisCell<T>.classForCoder()))
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.indicatorView.isHidden = true
        self.indicatorView.backgroundColor = self.theme.grid.backgroundColor.selected
        self.collectionView.addSubview(self.indicatorView)
    }
    
    open func reloadData() {
        self.contentView.layoutIfNeeded()
        self.collectionView.reloadData()
    }
    
    open func select(date: Date, animated: Bool) {
        
    }
    
    open func didSelect(date: Date, animated: Bool = true) {
        
    }
    
    
    #if TARGET_INTERFACE_BUILDER
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.collectionView.reloadData()
    }
    #endif
}
