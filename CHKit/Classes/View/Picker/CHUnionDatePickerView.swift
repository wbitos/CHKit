//
//  CHUnionDatePickerView.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/23.
//

import UIKit
import LunarTerm

open class CHUnionDatePickerView: CHPickerView {
    public class UionDateHeader: CHPickerView.HeaderView {
        open lazy var lunarLabel: UILabel = { () -> UILabel in
            let label = UILabel(frame: .zero)
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = UIColor.dynamicColor(light: 0x689a32, dark: 0x689a32)
            return label
        }()
        
        open lazy var lunarSwitch: UISwitch = { () -> UISwitch in
            let switcher = UISwitch(frame: .zero)
            return switcher
        }()
        
        open override func prepare() {
            self.lunarLabel.text = "农历"
            self.addSubview(self.lunarLabel)
            self.lunarLabel.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.leading.equalToSuperview().offset(20)
            }
            
            self.addSubview(self.lunarSwitch)
            self.lunarSwitch.snp.makeConstraints { [weak self](maker) in
                guard let strong = self else {
                    return
                }
                maker.centerY.equalToSuperview()
                maker.leading.equalTo(strong.lunarLabel.snp.trailing).offset(10)
            }
        }
    }
    
    open lazy var maxDate: Date = { () -> Date in
        let calendar = Calendar.current
        return calendar.date(from: DateComponents(calendar: calendar, timeZone: calendar.timeZone, era: nil, year: 2099, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)) ?? Date(timeIntervalSince1970: 0)
    }() {
        didSet {
            self.lmaxDate = LunarDate(solarDate: (self.maxDate as NSDate).getGregorianDate())
        }
    }
    
    open lazy var minDate: Date = { () -> Date in
        let calendar = Calendar.current
        return calendar.date(from: DateComponents(calendar: calendar, timeZone: calendar.timeZone, era: nil, year: 1901, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)) ?? Date(timeIntervalSince1970: 0)
    }() {
        didSet {
            self.lminDate = LunarDate(solarDate: (self.minDate as NSDate).getGregorianDate())
        }
    }
    
    private lazy var lminDate: LunarDate? = { () -> LunarDate? in
        let lminDate = LunarDate(solarDate: (self.minDate as NSDate).getGregorianDate())
        return lminDate
    }()
    
    private lazy var lmaxDate: LunarDate? = { () -> LunarDate? in
        let lmaxDate = LunarDate(solarDate: (self.maxDate as NSDate).getGregorianDate())
        return lmaxDate
    }()
    
    open var selectedDate: Date? = nil
    
    open var lunar: Bool = false
    
    open lazy var headerView: UionDateHeader = { () -> UionDateHeader in
        return UionDateHeader(frame: .zero)
    }()
    
    open lazy var pickerView: UIPickerView = { () -> UIPickerView in
        return UIPickerView(frame: .zero)
    }()
    
    open lazy var footerView: CHPickerView.FooterView = { () -> CHPickerView.FooterView in
        return CHPickerView.FooterView(frame: .zero)
    }()
    
    open var onChange: Closures.Action<Date>? = nil

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
        self.headerView.lunarSwitch.reactive.controlEvents(.valueChanged).observeValues { [weak self](switcher) in
            guard let strong = self else {
                return
            }
            strong.lunar = switcher.isOn
            strong.pickerView.reloadAllComponents()
        }
        
        self.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(50)
            maker.top.equalToSuperview()
        }
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.addSubview(self.pickerView)
        self.pickerView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(180)
            maker.top.equalTo(strong.headerView.snp.bottom)
        }
        
        self.addSubview(self.footerView)
        self.footerView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(50)
            maker.top.equalTo(strong.pickerView.snp.bottom)
        }
        
    }
    
    open func reloadData() {
        
    }
    
    open func select(date: Date, animated: Bool = true) {
        self.selectedDate = date
//        let ltDate = (date as NSDate).getGregorianDate()
        let minYear = self.minDate.component(component: .year)
        
        for i in 0..<3 {
            if i == 0 {
                let value = date.component(component: .year)
                self.pickerView.selectRow(value - minYear, inComponent: i, animated: animated)
                self.pickerView.reloadComponent(1)
                self.pickerView.reloadComponent(2)
            }
            else if i == 1 {
                let value = date.component(component: .month)
                self.pickerView.selectRow(value - 1, inComponent: i, animated: animated)
                self.pickerView.reloadComponent(1)
            }
            else if i == 2 {
                let value = date.component(component: .day)
                self.pickerView.selectRow(value - 1, inComponent: i, animated: animated)
            }
        }
    }
    
    public func pickerViewForLunar(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let lminDate = self.lminDate else {
            return 0
        }
        guard let lmaxDate = self.lmaxDate else {
            return 0
        }
        if component == 0 {
            return Int(lmaxDate.year - lminDate.year + 1)
        }
        else if component == 1 {
            let year = Int(lminDate.year) + pickerView.selectedRow(inComponent: 0)
            let leapMonth = Int(LunarDate.leapMonth(ofYear: Int32(year)))
            if year == lminDate.year {
                // 第一年
                return 12 - Int(lminDate.month) + 1 + (leapMonth > lminDate.month ? 1 : 0)
            }
            return (leapMonth > 0) ? 13 : 12
        }
        else if component == 2 {
            let year = Int(lminDate.year) + pickerView.selectedRow(inComponent: 0)
            let leapMonth = Int(LunarDate.leapMonth(ofYear: Int32(year)))
            if year == lminDate.year {
                var firstYearMonth = pickerView.selectedRow(inComponent: 1) + Int(lminDate.month)
                if firstYearMonth == Int(lminDate.month) {
                    var leap = ObjCBool(lminDate.leap)
                    return Int(LunarDate.days(ofYear: Int32(year), inMonth: Int32(firstYearMonth), leap: &leap)) - Int(lminDate.day) + 1
                }
                
                if leapMonth == 0 || firstYearMonth <= leapMonth {
                    return Int(LunarDate.days(ofYear: Int32(year), inMonth: Int32(firstYearMonth)))
                }
                firstYearMonth = firstYearMonth - 1
                if firstYearMonth == leapMonth {
                    var leap = ObjCBool(true)
                    return Int(LunarDate.days(ofYear: Int32(year), inMonth: Int32(firstYearMonth), leap: &leap))
                }
                return Int(LunarDate.days(ofYear: Int32(year), inMonth: Int32(firstYearMonth)))
            }
            
            var month = pickerView.selectedRow(inComponent: 1) + 1
            
            if leapMonth == 0 || month <= leapMonth {
                return Int(LunarDate.days(ofYear: Int32(year), inMonth: Int32(month)))
            }
            
            month = month - 1
            if month == leapMonth {
                var leap = ObjCBool(true)
                return Int(LunarDate.days(ofYear: Int32(year), inMonth: Int32(month), leap: &leap))
            }
            return Int(LunarDate.days(ofYear: Int32(year), inMonth: Int32(month)))
        }
        return 0
    }
    
    public func pickerViewForSolar(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            let minYear = self.minDate.component(component: .year)
            let maxYear = self.maxDate.component(component: .year)
            return maxYear - minYear + 1
        }
        else if component == 1 {
            return 12
        }
        else if component == 2 {
            let year = self.minDate.component(component: .year) + pickerView.selectedRow(inComponent: 0)
            let month = pickerView.selectedRow(inComponent: 1) + 1
            return YearMonth(year: year, month: month).daysInMonth()
        }
        return 0
    }
    
    public func pickerViewForSolar(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let minYear = self.minDate.component(component: .year)
            return "\(minYear + row)"
        }
        else if component == 1 {
            return "\(1 + row)"
        }
        return "\(1 + row)"
    }
    
    public func pickerViewForLunar(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let lminDate = self.lminDate else {
            return nil
        }
        if component == 0 {
            let year = Int(lminDate.year) + row
            return "\(year)"
        }
        else if component == 1 {
            let year = Int(lminDate.year) + pickerView.selectedRow(inComponent: 0)
            let leapMonth = Int(LunarDate.leapMonth(ofYear: Int32(year)))
            
            if year == lminDate.year {
                var firstYearMonth = row + Int(lminDate.month)
                if leapMonth == 0 || firstYearMonth <= leapMonth {
                    return LunarDate.lunarDisplay(forMonth: Int32(firstYearMonth), isLeap: false)
                }
                if lminDate.month < leapMonth {
                    firstYearMonth = firstYearMonth - 1
                }
                else if lminDate.month == leapMonth {
                    if !lminDate.leap {
                        firstYearMonth = firstYearMonth - 1
                    }
                }
                if firstYearMonth == leapMonth {
                    return LunarDate.lunarDisplay(forMonth: Int32(firstYearMonth), isLeap: true)
                }
                return LunarDate.lunarDisplay(forMonth: Int32(firstYearMonth), isLeap: false)
            }
            
            var month = row + 1

            if leapMonth == 0 || month <= leapMonth {
                return LunarDate.lunarDisplay(forMonth: Int32(month), isLeap: false)
            }
            
            month = month - 1
            if month == leapMonth {
                return LunarDate.lunarDisplay(forMonth: Int32(month), isLeap: true)
            }
            return LunarDate.lunarDisplay(forMonth: Int32(month), isLeap: false)
        }
        else if component == 2 {
            let year = Int(lminDate.year) + pickerView.selectedRow(inComponent: 0)
            if year == lminDate.year {
                let firstYearMonth = pickerView.selectedRow(inComponent: 1) + Int(lminDate.month)
                if firstYearMonth == Int(lminDate.month) {
                    let firstYearMonthDay = Int(lminDate.day) + row
                    return LunarDate.lunarDisplay(forDay: Int32(firstYearMonthDay))
                }
            }
            
            let day = row + 1
            return LunarDate.lunarDisplay(forDay: Int32(day))
        }
        return nil
    }
}

extension CHUnionDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lunar ? self.pickerViewForLunar(pickerView, numberOfRowsInComponent: component) : self.pickerViewForSolar(pickerView, numberOfRowsInComponent: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.lunar ? self.pickerViewForLunar(pickerView, titleForRow: row, forComponent: component) : self.pickerViewForSolar(pickerView, titleForRow: row, forComponent: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        }
        else if component == 1 {
            pickerView.reloadComponent(2)
        }
        
        if self.lunar {
            guard let lminDate = self.lminDate else {
                return
            }
            guard let lmaxDate = self.lmaxDate else {
                return
            }
            
            let year = Int(lminDate.year) + self.pickerView.selectedRow(inComponent: 0)
            if year == Int(lminDate.year) {
                
                
            }
            var month = self.pickerView.selectedRow(inComponent: 1) + 1
            let day = self.pickerView.selectedRow(inComponent: 2) + 1
            let leapMonthInYear = Int(LunarDate.leapMonth(ofYear: Int32(year)))
            if leapMonthInYear == 0 || month <= leapMonthInYear {
                if let lDate = LunarDate(year: Int32(year), month: Int32(month), day: Int32(day), leap: false) {
                    self.selectedDate = NSDate(fromCFGregorianDate: lDate.solarDate) as Date
                }
            }
            month = month - 1
            let leap = month == leapMonthInYear
            if let lDate = LunarDate(year: Int32(year), month: Int32(month), day: Int32(day), leap: leap) {
                self.selectedDate = NSDate(fromCFGregorianDate: lDate.solarDate) as Date
            }
        }
        else {
            let minYear = self.minDate.component(component: .year)
            let year = minYear + self.pickerView.selectedRow(inComponent: 0)
            let month = self.pickerView.selectedRow(inComponent: 1) + 1
            let day = self.pickerView.selectedRow(inComponent: 2) + 1
            
            self.selectedDate = Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: Calendar.current.timeZone, era: nil, year: year, month: month, day: day, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil))
        }
    }
}
