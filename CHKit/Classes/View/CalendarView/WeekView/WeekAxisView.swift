//
//  WeekAxisView.swift
//  Coco
//
//  Created by wbitos on 2019/8/29.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit

public protocol WeekAxisViewDelegate: NSObjectProtocol {
    func weekAxisView(_ weekAxisView: WeekAxisView, didShow yearWeek:YearWeek)
    func weekAxisView(_ weekAxisView: WeekAxisView, shouldSelect date: Date)
    func weekAxisView(_ weekAxisView: WeekAxisView, willSelect date: Date)
    func weekAxisView(_ weekAxisView: WeekAxisView, didSelect date: Date)
}

public protocol WeekAxisViewDataSource: NSObjectProtocol {
    func weekAxisView(_ weekAxisView: WeekAxisView, dataSourceForDate date: Date) -> CalendarViewDateDataSource
}

@IBDesignable
open class WeekAxisView: TimeAxisView<WeekView> {
    open weak var delegate: WeekAxisViewDelegate? = nil
    open weak var dataSource: WeekAxisViewDataSource? = nil

    open var from: YearWeek = YearWeek(year: 1901, week: 1, firstWeekday: .sunday)
    open var count: Int = YearWeek(year: 2101, week: 1, firstWeekday: .sunday).diffWeek(another: YearWeek(year: 1901, week: 1, firstWeekday: .sunday))
    
//    open var current: YearMonth = YearMonth.current() {
//        didSet {
//            let index = self.current.diffMonth(another: self.from)
//            self.contentView.layoutIfNeeded()
//            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
//        }
//    }
        
    override func prepare() {
        super.prepare()
        self.indicatorView.isHidden = false
        
        self.collectionView.isPagingEnabled = true
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(WeekAxisCell.self, forCellWithReuseIdentifier: NSStringFromClass(WeekAxisCell.classForCoder()))
    }
    
    func calculatePage() {
        let current = Int(self.collectionView.contentOffset.x / self.bounds.size.width)
        let yearWeek = self.from.next(week: current)
        self.delegate?.weekAxisView(self, didShow: yearWeek)
    }
    
    open override func select(date: Date, animated: Bool) {
        self.select(date: date, animated: animated, force: false)
    }
    
    open func select(date: Date, animated: Bool, force: Bool) {
        if self.selectedDate.isSame(anotherDate: date) && !force {
            return
        }
        self.selectedDate = date
        let index = date.yearWeek(firstDayOfWeek: self.from.firstDayOfWeek).diffWeek(another: self.from)
        self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: animated)
        if let axisCell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? WeekAxisCell {
            axisCell.itemView.collectionView.reloadData()
        }
        self.didSelect(date: date)
    }
    
    open func currentWeekView() -> WeekView? {
        return self.currentWeekAxisCell()?.itemView
    }
    
    open func currentWeekAxisCell() -> WeekAxisCell? {
        return self.collectionView.cellForItem(at: IndexPath(item: self.currentPage(), section: 0)) as? WeekAxisCell
    }
    
    open func currentPage() -> Int {
        let current = Int(self.collectionView.contentOffset.x / self.bounds.size.width)
        return current
    }
    
    open override func didSelect(date: Date, animated: Bool = true) {
        guard let monthView = self.currentWeekView() else {
            return
        }
        self.delegate?.weekAxisView(self, willSelect: date)
        self.selectedDate = date
        self.collectionView.bringSubviewToFront(self.indicatorView)
        let dataSourceForDate = self.dataSource?.weekAxisView(self, dataSourceForDate: date)
        UIView.animate(withDuration: animated ? 0.25 : 0.0, delay: 0.0, options: .curveEaseInOut) {
            let frame = self.rect(for: date)
            let page = date.yearWeek(firstDayOfWeek: self.from.firstDayOfWeek).diffWeek(another: self.from)

            let pageOffset = CGFloat(page * Int(self.bounds.size.width))
            let size: CGFloat = 50 //min(frame.size.width, frame.size.height)
            self.indicatorView.layer.cornerRadius = size / 2.0
            self.indicatorView.isHidden = false
            self.indicatorView.data = dataSourceForDate
            self.indicatorView.snp.remakeConstraints { (maker) in
                maker.leading.equalToSuperview().offset(frame.origin.x + (frame.size.width - size) / 2.0 + pageOffset)
                maker.top.equalToSuperview().offset(frame.origin.y + (frame.size.height - size) / 2.0 )
                maker.width.equalTo(size)
                maker.height.equalTo(size)
            }
            self.indicatorView.workOrRestFlagLabel.isHidden = true
            monthView.reloadData(for: date)
            self.contentView.layoutIfNeeded()
        } completion: { (finished) in
            self.delegate?.weekAxisView(self, didSelect: date)
        }
    }
    
    open func rect(for date: Date) -> CGRect {
        let rows = 5
        let width = UIScreen.main.bounds.size.width / 7.0
        let height = (width * 5.6) / CGFloat(rows)
        let index = date.diffDays(to: date.yearWeek(firstDayOfWeek: self.from.firstDayOfWeek).firstDay())
        let section = 0
        let row = index % 7
        return CGRect(x: CGFloat(row) * width, y: CGFloat(section) * height, width: width, height: height)
    }
}

extension WeekAxisView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let weekCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(WeekAxisCell.classForCoder()), for: indexPath) as? WeekAxisCell {
            weekCell.backgroundColor = .clear
            weekCell.itemView.backgroundColor = .clear
            weekCell.itemView.delegate = self
            weekCell.itemView.dataSource = self
            weekCell.itemView.theme = self.theme
            weekCell.itemView.axisView = self
            let yearWeek = self.from.next(week: indexPath.row)
            weekCell.itemView.yearWeek = yearWeek
            return weekCell
        }
        return UICollectionViewCell()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            if let frame = self.currentWeekView()?.rect(for: self.selectedDate) {
                let offset = scrollView.contentOffset.x - self.bounds.size.width * CGFloat(self.currentPage())
//                self.indicatorView.snp.updateConstraints { (maker) in
//                    maker.leading.equalToSuperview().offset(frame.origin.x - offset)
//                }
            }
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.calculatePage()
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.calculatePage()
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
}

extension WeekAxisView: WeekViewDelegate, WeekViewDataSource {
    public func weekView(_ weekView: WeekView, dataSourceForDate date: Date) -> CalendarViewDateDataSource {
        return self.dataSource?.weekAxisView(self, dataSourceForDate: date) ?? CalendarViewDateDataSource()
    }
    
    public func weekView(_ weekView: WeekView, willSelectDate date: Date) {
        
    }
    
    public func weekView(_ weekView: WeekView, didSelectDate date : Date) {
        self.selectedDate = date
        self.didSelect(date: date)
    }
    
    public func weekView(_ weekView: WeekView, willDeselectDate date: Date) {
        
    }
    
    public func weekView(_ weekView: WeekView, didDeselectDate date: Date) {

    }
}
