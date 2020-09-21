//
//  Date+CurrentCalendar.swift
//  Coco
//
//  Created by suyu on 2019/9/2.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit

extension Date {
    public func weekday(calendar: Foundation.Calendar = Calendar.current) -> WeekDay {
        return WeekDay(rawValue: calendar.component(Calendar.Component.weekday, from: self) - 1) ?? .sunday
    }
    
    public func day(calendar: Foundation.Calendar = Calendar.current) -> Int {
        return calendar.component(Calendar.Component.day, from: self)
    }
    
    public func month(calendar: Foundation.Calendar = Calendar.current) -> Int {
        return calendar.component(Calendar.Component.month, from: self)
    }
    
    public func yearMonth(calendar: Foundation.Calendar = Calendar.current) -> YearMonth {
        let year = calendar.component(Calendar.Component.year, from: self)
        let month = calendar.component(Calendar.Component.month, from: self)
        return YearMonth(year: year, month: month)
    }
    
    public func isToday(calendar: Foundation.Calendar = Calendar.current) -> Bool {
        return calendar.isDateInToday(self)
    }
    
    public func isSame(anotherDate date: Date, calendar: Foundation.Calendar = Calendar.current) -> Bool {
        return calendar.isDate(date, inSameDayAs: self)
    }
    
    public func format(_ format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    public static func parse(_ content: String, format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: content)
    }
}
