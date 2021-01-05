//
//  MonthAxisView.swift
//  Coco
//
//  Created by wbitos on 2019/8/29.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit

public protocol MonthAxisViewDelegate: NSObjectProtocol {
    func monthAxisView(_ monthAxisView: MonthAxisView, didShow yearMonth:YearMonth)
    func monthAxisView(_ monthAxisView: MonthAxisView, shouldSelect date: Date)
    func monthAxisView(_ monthAxisView: MonthAxisView, willSelect date: Date)
    func monthAxisView(_ monthAxisView: MonthAxisView, didSelect date: Date)
}

public protocol MonthAxisViewDataSource: NSObjectProtocol {
    func monthAxisView(_ monthAxisView: MonthAxisView, dataSourceForDate date: Date) -> CalendarViewDateDataSource
}

@IBDesignable
open class MonthAxisView: TimeAxisView<MonthView> {
    open weak var delegate: MonthAxisViewDelegate? = nil
    open weak var dataSource: MonthAxisViewDataSource? = nil

    open var from: YearMonth = YearMonth(year: 1901, month: 1)
    open var count: Int = 12 * 200
    
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
        self.collectionView.register(MonthAxisCell.self, forCellWithReuseIdentifier: NSStringFromClass(MonthAxisCell.classForCoder()))
    }
    
    func calculatePage() {
        let current = Int(self.collectionView.contentOffset.x / self.bounds.size.width)
        let yearMonth = self.from.next(month: current)
        self.delegate?.monthAxisView(self, didShow: yearMonth)
    }
    
    open override func select(date: Date, animated: Bool) {
        if self.selectedDate.isSame(anotherDate: date) {
            return
        }
        self.selectedDate = date
        let index = date.yearMonth().diffMonth(another: self.from)
        self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: animated)
        if let axisCell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MonthAxisCell {
            axisCell.itemView.collectionView.reloadData()
        }
        self.didSelect(date: date)
    }
    
    open func currentMonthView() -> MonthView? {
        return self.currentMonthAxisCell()?.itemView
    }
    
    open func currentMonthAxisCell() -> MonthAxisCell? {
        return self.collectionView.cellForItem(at: IndexPath(item: self.currentPage(), section: 0)) as? MonthAxisCell
    }
    
    open func currentPage() -> Int {
        let current = Int(self.collectionView.contentOffset.x / self.bounds.size.width)
        return current
    }
    
    open override func didSelect(date: Date, animated: Bool = true) {
        guard let monthView = self.currentMonthView() else {
            return
        }
        self.delegate?.monthAxisView(self, willSelect: date)
        self.selectedDate = date
        self.collectionView.bringSubviewToFront(self.indicatorView)
        let dataSourceForDate = self.dataSource?.monthAxisView(self, dataSourceForDate: date)
        UIView.animate(withDuration: animated ? 0.25 : 0.0, delay: 0.0, options: .curveEaseInOut) {
            let frame = self.rect(for: date)
            let page = date.yearMonth().diffMonth(another: self.from)

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
            self.delegate?.monthAxisView(self, didSelect: date)
        }
    }
    
    open func rect(for date: Date) -> CGRect {
        let yearMonth = date.yearMonth()
        let rows = yearMonth.weeks
        let width = UIScreen.main.bounds.size.width / 7.0
        let height = (width * 5.6) / CGFloat(rows)
        let index = yearMonth.indexOfMonth(forDate: date)
        let section = Int(floor(Double(index) / 7.0))
        let row = index % 7
        
        return CGRect(x: CGFloat(row) * width, y: CGFloat(section) * height, width: width, height: height)
    }
}

extension MonthAxisView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let monthCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MonthAxisCell.classForCoder()), for: indexPath) as? MonthAxisCell {
            monthCell.backgroundColor = .clear
            monthCell.itemView.backgroundColor = .clear
            monthCell.itemView.delegate = self
            monthCell.itemView.dataSource = self
            monthCell.itemView.theme = self.theme
            monthCell.itemView.axisView = self
            let yearMonth = self.from.next(month: indexPath.row)
            monthCell.itemView.yearMonth = yearMonth
            return monthCell
        }
        return UICollectionViewCell()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            if let frame = self.currentMonthView()?.rect(for: self.selectedDate) {
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

extension MonthAxisView: MonthViewDelegate, MonthViewDataSource {
    public func monthView(_ monthView: MonthView, dataSourceForDate date: Date) -> CalendarViewDateDataSource {
        return self.dataSource?.monthAxisView(self, dataSourceForDate: date) ?? CalendarViewDateDataSource()
    }
    
    public func monthView(_ monthView: MonthView, willSelectDate date: Date) {
        
    }
    
    public func monthView(_ monthView: MonthView, didSelectDate date : Date) {
        self.selectedDate = date
        self.didSelect(date: date)
    }
    
    public func monthView(_ monthView: MonthView, willDeselectDate date: Date) {
        
    }
    
    public func monthView(_ monthView: MonthView, didDeselectDate date: Date) {

    }
}
