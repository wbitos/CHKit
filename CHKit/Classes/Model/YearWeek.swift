//
//  YearWeek.swift
//  Coco
//
//  Created by 王义平 on 2022/1/12.
//  Copyright © 2022 365rili.com. All rights reserved.
//

import UIKit

open class YearWeek: NSObject {
    private(set) var year: Int = 2000
    private(set) var week: Int = 1

    private(set) var firstDayOfWeek: WeekDay = .sunday {
        didSet {
            
        }
    }
    
    init(year: Int, week: Int = 1, firstWeekday: WeekDay = .sunday) {
        self.year = year
        self.week = week
        self.firstDayOfWeek = firstWeekday
        super.init()
    }
    
    public static func current() -> YearWeek {
        return YearWeek.yearWeek(for: Date())
    }
    
    public static func yearWeek(for date: Date, firstWeekday: WeekDay = .sunday) -> YearWeek {
        // TODO: FixME:
        let week = date.weekOfYear(firstWeekday: firstWeekday)
        let calendar = Calendar.current
        let components = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.weekOfYear, Calendar.Component.weekday]), from: date)
        return YearWeek(year: components.year ?? 2000, week: week)
    }
    
    public static func weeks(inYear year: Int, with firstWeekday: WeekDay = .sunday) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = 12
        components.day = 31
        components.hour = 12
        components.minute = 0
        components.second = 0

        var calendar = Calendar.current
        calendar.firstWeekday = firstWeekday.rawValue
        calendar.minimumDaysInFirstWeek = 7
        if let lastDate = calendar.date(from: components) {
            return lastDate.weekOfYear(firstWeekday: firstWeekday)
        }
        return 54
    }

    public func weeksInYear() -> Int {
        return YearWeek.weeks(inYear: self.year, with: self.firstDayOfWeek)
    }
    
    public func prev(week: Int = -1) -> YearWeek {
        return self.next(week: week)
    }

    public func next(week: Int = 1) -> YearWeek {
        let day = self.firstDay().add(component: .day, value: 7 * week)
        return YearWeek.yearWeek(for: day)
    }
    
    public func firstDay() -> Date {
        let firstWeekday =  (self.firstDayOfWeek == .sunday) ? 1 : 2
        var calendar = Calendar.current
        calendar.firstWeekday = firstWeekday;
        calendar.minimumDaysInFirstWeek = 7;
        
        var components = DateComponents()
        components.year = self.year
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let firstDayOfYear = calendar.date(from: components) ?? Date()
        let firstDayComponents = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.weekOfYear, Calendar.Component.yearForWeekOfYear, Calendar.Component.weekday]), from: firstDayOfYear)
        
        if firstDayComponents.yearForWeekOfYear != self.year {
            if self.week == 1 {
                var c = DateComponents()
                c.year = self.year
                c.month = 1
                c.day = 1
                c.hour = 0
                c.minute = 0
                c.second = 0
                return (calendar.date(from: c) ?? Date())
            }
            else {
                var c = DateComponents()
                c.year = self.year
                c.weekOfYear = self.week - 1
                c.weekday = firstWeekday
                c.hour = 0
                c.minute = 0
                c.second = 0
                return (calendar.date(from: c) ?? Date())
            }
        }
        
        var c = DateComponents()
        c.year = self.year
        c.weekOfYear = self.week
        c.weekday = firstWeekday
        c.hour = 0
        c.minute = 0
        c.second = 0
        return (calendar.date(from: c) ?? Date())
    }
    
    public func isEqualToYearWeek(_ another: YearWeek) -> Bool {
        return self.year == another.year && self.week == another.week
    }
    
    public func diffWeek(another: YearWeek) -> Int {
        return Int(Double(self.firstDay().diffDays(to: another.firstDay())) / 7.0)
    }
    
    public func getFirstDayOfWeek() -> WeekDay {
        return self.firstDayOfWeek
    }
}
