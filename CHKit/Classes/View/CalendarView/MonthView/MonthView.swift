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

public protocol MonthViewDelegate: NSObjectProtocol {
    func monthView(_ monthView: MonthView, willSelectDate date: Date)
    func monthView(_ monthView: MonthView, didSelectDate date: Date)
    func monthView(_ monthView: MonthView, willDeselectDate date: Date)
    func monthView(_ monthView: MonthView, didDeselectDate date: Date)
}

public protocol MonthViewDataSource: NSObjectProtocol {
    func monthView(_ monthView: MonthView, dataSourceForDate date: Date) -> CalendarViewDateDataSource
}

@IBDesignable
open class MonthView: CalendarView {
    open weak var delegate: MonthViewDelegate? = nil
    open weak var dataSource: MonthViewDataSource? = nil
        
    open weak var axisView: MonthAxisView? = nil
    
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
    
    var firstWeekday: WeekDay = WeekDay.sunday {
        didSet {
            self.yearMonth = YearMonth(year: self.yearMonth.year, month: self.yearMonth.month, firstWeekday: self.firstWeekday)
            self.collectionView.reloadData()
        }
    }
    
    var yearMonth: YearMonth = { () -> YearMonth in
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month]), from: date)
        return YearMonth(year: components.year ?? date.yearMonth().year, month: components.month ?? date.yearMonth().month)
//        return YearMonth(year: components.year ?? 2019, month: components.month ?? 8)
        }() {
        didSet {
            self.collectionView.reloadData()
        }
    }
        
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
        self.collectionView.register(MonthGridCell.self, forCellWithReuseIdentifier: NSStringFromClass(MonthGridCell.classForCoder()))
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
        if !date.yearMonth().isEqualToYearMonth(self.yearMonth) {
            return
        }
        
        let rows = self.yearMonth.weeks
        
        let width = self.bounds.size.width / 7.0
        let height = (width * 5.6) / CGFloat(rows)
        
        let lastSelectedDate = self.axisView?.selectedDate
        var reloadIndexPaths: [IndexPath] = []
        if let lstDate = lastSelectedDate {
            if lstDate.yearMonth().isEqualToYearMonth(self.yearMonth) {
                let lastIndex = self.yearMonth.indexOfMonth(forDate: lstDate)
                let lastSection = Int(floor(Double(lastIndex) / 7.0))
                let lastRow = lastIndex % 7
                reloadIndexPaths.append(IndexPath(item: lastRow, section: lastSection))
            }
        }
        
        self.delegate?.monthView(self, didSelectDate: date)

        if !(lastSelectedDate?.isSame(anotherDate: date) ?? false) {
            
            let index = self.yearMonth.indexOfMonth(forDate: date)
            let section = Int(floor(Double(index) / 7.0))
            let row = index % 7
            reloadIndexPaths.append(IndexPath(item: row, section: section))

            UIView.animate(withDuration: 0.25) {
                self.collectionView.reloadItems(at: reloadIndexPaths)
            } completion: { (finished) in
                
            }
//            UIView.setAnimationsEnabled(false)
//            collectionView.performBatchUpdates {
//            } completion: { (done) in
//                UIView.setAnimationsEnabled(true)
//
//
//            }
        }
    }
    
    open func rect(for date: Date) -> CGRect {
        if !date.yearMonth().isEqualToYearMonth(self.yearMonth) {
            return .zero
        }
        guard let indexPath = self.indexPath(for: date) else {
            return .zero
        }
        let rows = self.yearMonth.weeks
        let width = self.bounds.size.width / 7.0
        let height = (width * 5.6) / CGFloat(rows)
        
        let section = indexPath.section
        let row = indexPath.item
        
        return CGRect(x: CGFloat(row) * width, y: CGFloat(section) * height, width: width, height: height)
    }
    
    open func indexPath(for date: Date) -> IndexPath? {
        if !date.yearMonth().isEqualToYearMonth(self.yearMonth) {
            return nil
        }
        let index = self.yearMonth.indexOfMonth(forDate: date)
        let section = Int(floor(Double(index) / 7.0))
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

extension MonthView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.yearMonth.weeks
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
        let rows = self.yearMonth.weeks
        let width = self.bounds.size.width / 7.0
        let height = (width * 5.6) / CGFloat(rows)
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let yearMonth = self.yearMonth
        
        let index = indexPath.section * 7 + indexPath.row
        let firstDayOfMonth = yearMonth.firstDay()
        let firstDayIndex = yearMonth.index()
        let sDate = firstDayOfMonth.addingTimeInterval(Double(index - firstDayIndex) * 86400)
        let lDate = LunarDate(solarDate: (sDate as NSDate).getGregorianDate())
        
        let item = self.dataSource?.monthView(self, dataSourceForDate: sDate)
        
        if let monthCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MonthGridCell.classForCoder()), for: indexPath) as? MonthGridCell {
//            monthCell.gridView.dateView.dayLabel.text = "\(sDate.day())"
//            monthCell.gridView.dateView.lunarLabel.text = "\(lDate?.lunarDayDisplay() ?? "")"
//            
//            if self.axisView?.selectedDate.isSame(anotherDate: sDate) ?? false {
//                monthCell.gridView.dateView.dayLabel.textColor = self.theme.solarDate.textColor.selected
//                monthCell.gridView.dateView.lunarLabel.textColor = self.theme.lunarDate.textColor.selected
//            }
//            else {
//                monthCell.gridView.dateView.dayLabel.textColor = self.theme.solarDate.textColor.normal
//                monthCell.gridView.dateView.lunarLabel.textColor = self.theme.lunarDate.textColor.normal
//            }
//
//            monthCell.gridView.dateView.dayLabel.font = self.theme.solarDate.font.normal
//            monthCell.gridView.dateView.lunarLabel.font = self.theme.lunarDate.font.normal
//            
//            monthCell.gridView.workOrRestFlagLabel.isHidden = true
//            if let workOrRest = item?.statutoryHolidayStatus {
//                monthCell.gridView.workOrRestFlagLabel.isHidden = false
//                monthCell.gridView.workOrRestFlagLabel.text = (workOrRest == 1) ? "休" : "班"
//                monthCell.gridView.workOrRestFlagLabel.textColor = UIColor.dynamicColor(light: (workOrRest == 1) ? 0xbd4622 : 0x689a32, dark: (workOrRest == 1) ? 0xbd4622 : 0x689a32)
//            }
//            
//            if let festival = item?.festivals.first {
//                monthCell.gridView.dateView.lunarLabel.text = "\(festival.name)"
//            }
            let isSameMonth = sDate.yearMonth().isEqualToYearMonth(yearMonth)
            monthCell.gridView.isHidden = !isSameMonth
            monthCell.gridView.data = item
            return monthCell
        }
        return MonthGridCell(frame: .zero)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = indexPath.section * 7 + indexPath.row
        let firstDayOfMonth = self.yearMonth.firstDay()
        let firstDayIndex = self.yearMonth.index()
        let sDate = firstDayOfMonth.add(component: .day, value:index - firstDayIndex)
        self.select(date: sDate, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//
//    }
}

extension MonthView: UITableViewDataSource, UITableViewDelegate {
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
