//
//  YearMonth.swift
//  Coco
//
//  Created by suyu on 2019/9/2.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit

class YearMonth: NSObject {
    static var days: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    private(set) var year: Int
    private(set) var month: Int = 0
    private(set) var weeks: Int = 0
    
    var firstDayOfWeek: WeekDay = .sunday {

        didSet {
            self.calculateWeeks()
        }
    }
    
    init(year: Int, month: Int, firstWeekday: WeekDay = .sunday) {

        self.year = year
        self.month = month
        super.init()
        self.calculateWeeks()
    }
    
    static func current() -> YearMonth {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month]), from: date)
        return YearMonth(year: components.year ?? Date().yearMonth().year, month: components.month ?? Date().yearMonth().month)

    }
    
    func isCurrentYear() -> Bool {
        return self.year == YearMonth.current().year
    }
    
    func isCurrentMonth() -> Bool {
        let current = YearMonth.current()
        return self.year == current.year && self.month == current.month
    }
    
    func next(month: Int = 1) -> YearMonth {
        var cy = self.year + Int(Double(month - 1) / 12.0)
        var cm = self.month + (month - 1) % 12 + 1
        
        if cm > 12 {
            cy += 1
            cm -= 12
        }
        else if cm < 1 {
            cy -= 1
            cm += 12
        }
        return YearMonth(year: cy, month: cm, firstWeekday: self.firstDayOfWeek)
    }
    
    func firstDay() -> Date {
        return Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0))!
    }
    
    func lastDay() -> Date {
        return self.next().firstDay().addingTimeInterval(-1)
    }
    
    func daysInMonth() -> Int {
        if self.month != 2 {
            return YearMonth.days[self.month - 1]
        }
        return YearMonth.isYearLeap(solarYear: self.year) ? 29 : 28
    }
    
    static func isYearLeap(solarYear year: Int) -> Bool {
        return (((year % 4) == 0 && (year % 100) != 0) || (year % 400) == 0)
    }
    // 0 1 2 3 4 5 6
    // 6 0 1 2 3 4 5
    // 5 6 0 1 2 3 4
    // 4 5 6 0 1 2 3
    // 3 4 5 6 0 1 2
    // 2 3 4 5 6 0 1
    // 1 2 3 4 5 6 0
    func calculateWeeks() {
        let days = self.daysInMonth()
        
        let add: [Int] = [0, 1, 2, 3, 4, 5, 6].map { (i) -> Int in
            return (i - self.firstDayOfWeek.rawValue + 7) % 7
        }
        
        let weeks = Int(ceil(Double(days + add[self.firstDay().weekday().rawValue]) / 7.0))
        self.weeks = weeks
    }
    
    func index() -> Int {
        let add: [Int] = [0, 1, 2, 3, 4, 5, 6].map { (i) -> Int in
            return (i - self.firstDayOfWeek.rawValue + 7) % 7
        }
        return add[self.firstDay().weekday().rawValue]
    }
    
    func diffMonth(another: YearMonth) -> Int {
        return (self.year - another.year) * 12 + (self.month - another.month)
    }
    
    func toString() -> String {
        return String(format: "%4d-%02d", self.year, self.month)
    }
    
    static func parse(dateString: String) -> YearMonth? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        if let date = dateFormatter.date(from: dateString) {
            return date.yearMonth()
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            return date.yearMonth()
        }
        return nil
    }
    
    func isEqualToYearMonth(_ another: YearMonth) -> Bool {
        return self.year == another.year && self.month == another.month
    }
    
    func weekOfMonth(forDate date: Date) -> Int {
        let firstDay = self.firstDay().addingTimeInterval(Double(-86400 * self.index()))
        return Int(floor(date.timeIntervalSince(firstDay) / Double(86400.0 * 7)))
    }
}
