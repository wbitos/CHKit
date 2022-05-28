//
//  MonthView.swift
//  Coco
//
//  Created by suyu on 2019/8/27.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit
import SnapKit
import LunarTerm

public protocol WeekViewDelegate: NSObjectProtocol {
    func weekView(_ monthView: WeekView, willSelectDate date: Date)
    func weekView(_ monthView: WeekView, didSelectDate date: Date)
    func weekView(_ monthView: WeekView, willDeselectDate date: Date)
    func weekView(_ monthView: WeekView, didDeselectDate date: Date)
}

public protocol WeekViewDataSource: NSObjectProtocol {
    func weekView(_ monthView: WeekView, dataSourceForDate date: Date) -> CalendarViewDateDataSource
}

@IBDesignable
open class WeekView: CalendarView {
    open weak var delegate: WeekViewDelegate? = nil
    open weak var dataSource: WeekViewDataSource? = nil
        
    open weak var axisView: WeekAxisView? = nil
    
    var contentView = UIView()
    
    fileprivate(set) var needsAdjustingViewFrame = true
    
    open var collectionView: UICollectionView = { () -> UICollectionView in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var scheduleView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    var yearWeek: YearWeek = { () -> YearWeek in
        return YearWeek.current()
        }() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var yearMonth: YearMonth? = nil
    
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

        self.collectionView.backgroundColor = .clear
        self.collectionView.isScrollEnabled = false
        self.collectionView.register(DateGridCell.self, forCellWithReuseIdentifier: NSStringFromClass(DateGridCell.classForCoder()))
        self.collectionView.register(ScheduleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(ScheduleCollectionReusableView.classForCoder()))
        self.collectionView.register(ScheduleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(ScheduleCollectionReusableView.classForCoder()))
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.scheduleView.delegate = self
        self.scheduleView.dataSource = self
        
        self.setNeedsLayout()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if self.needsAdjustingViewFrame {
//            self.needsAdjustingViewFrame = false
//            self.contentView.frame = self.bounds
//            self.collectionView.frame = self.contentView.bounds
//        }
//    }
    
    #if TARGET_INTERFACE_BUILDER
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.collectionView.reloadData()
    }
    #endif
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    open func select(date: Date, animated: Bool = true) {
        if !date.yearWeek(firstDayOfWeek: self.yearWeek.firstDayOfWeek).isEqualToYearWeek(self.yearWeek) {
            return
        }

        let lastSelectedDate = self.axisView?.selectedDate
        var reloadIndexPaths: [IndexPath] = []
        if let lstDate = lastSelectedDate {
            if lstDate.yearWeek(firstDayOfWeek: self.yearWeek.firstDayOfWeek).isEqualToYearWeek(self.yearWeek) {
                let lastIndex = lstDate.diffDays(to: self.yearWeek.firstDay())
                let lastSection = 0
                let lastRow = lastIndex % 7
                reloadIndexPaths.append(IndexPath(item: lastRow, section: lastSection))
            }
        }
        self.delegate?.weekView(self, didSelectDate: date)
        if !(lastSelectedDate?.isSame(anotherDate: date) ?? false) {
            
            let index = date.diffDays(to: self.yearWeek.firstDay())
            let section = 0
            let row = index % 7
            reloadIndexPaths.append(IndexPath(item: row, section: section))

            UIView.animate(withDuration: 0.25) {
                self.collectionView.reloadItems(at: reloadIndexPaths)
            } completion: { (finished) in
                
            }
        }
    }
    
    open func rect(for date: Date) -> CGRect {
        if !date.yearWeek(firstDayOfWeek: self.yearWeek.firstDayOfWeek).isEqualToYearWeek(self.yearWeek) {
            return .zero
        }
        guard let indexPath = self.indexPath(for: date) else {
            return .zero
        }
        let width = self.bounds.size.width / 7.0
        let height = (width * 5.6) / 5.0        
        let section = indexPath.section
        let row = indexPath.item
        return CGRect(x: CGFloat(row) * width, y: CGFloat(section) * height, width: width, height: height)
    }
    
    open func indexPath(for date: Date) -> IndexPath? {
        if !date.yearWeek(firstDayOfWeek: self.yearWeek.firstDayOfWeek).isEqualToYearWeek(self.yearWeek) {
            return nil
        }
        let index = date.diffDays(to: self.yearWeek.firstDay())
        let section = 0
        let row = index % 7
        return IndexPath(item: row, section: section)
    }
    
    open func reloadData() {
        self.collectionView.reloadData()
    }
    
    open func reloadData(for date: Date) {
        guard let indexPath = self.indexPath(for: date) else {
            return
        }
        self.collectionView.reloadItems(at: [indexPath])
    }
}

extension WeekView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(ScheduleCollectionReusableView.classForCoder()), for: indexPath)
        reusableView.backgroundColor = .clear
        return reusableView
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rows = 5
        let width = self.bounds.size.width / 7.0
        let height = (width * 5.6) / CGFloat(rows)
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let sDate = self.yearWeek.firstDay().add(component: .day, value: index)
        let item = self.dataSource?.weekView(self, dataSourceForDate: sDate)
        
        if let weekCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(DateGridCell.classForCoder()), for: indexPath) as? DateGridCell {
            weekCell.gridView.data = item
            return weekCell
        }
        return DateGridCell(frame: .zero)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = indexPath.row
        let sDate = self.yearWeek.firstDay().add(component: .day, value: index)
        self.select(date: sDate, animated: true)
    }
}

extension WeekView: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
