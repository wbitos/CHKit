//
//  Date+CurrentCalendar.swift
//  Coco
//
//  Created by suyu on 2019/9/2.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit

public extension Date {
    func weekday(calendar: Foundation.Calendar = Calendar.current) -> WeekDay {
        return WeekDay(rawValue: calendar.component(Calendar.Component.weekday, from: self)) ?? .sunday
    }
    
    func day(calendar: Foundation.Calendar = Calendar.current) -> Int {
        return calendar.component(Calendar.Component.day, from: self)
    }
    
    func month(calendar: Foundation.Calendar = Calendar.current) -> Int {
        return calendar.component(Calendar.Component.month, from: self)
    }
    
    func hour(calendar: Foundation.Calendar = Calendar.current) -> Int {
        return calendar.component(Calendar.Component.hour, from: self)
    }
    
    func minute(calendar: Foundation.Calendar = Calendar.current) -> Int {
        return calendar.component(Calendar.Component.minute, from: self)
    }
    
    func component(component: Calendar.Component, of calendar: Foundation.Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func yearMonth(calendar: Foundation.Calendar = Calendar.current) -> YearMonth {
        let year = calendar.component(Calendar.Component.year, from: self)
        let month = calendar.component(Calendar.Component.month, from: self)
        return YearMonth(year: year, month: month)
    }
    
    func yearWeek(calendar: Foundation.Calendar = Calendar.current, firstDayOfWeek: WeekDay) -> YearWeek {
        return YearWeek.current()
    }
    
    func isToday(calendar: Foundation.Calendar = Calendar.current) -> Bool {
        return calendar.isDateInToday(self)
    }
    
    func isTomorrow(calendar: Foundation.Calendar = Calendar.current) -> Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    func isSame(anotherDate date: Date, calendar: Foundation.Calendar = Calendar.current) -> Bool {
        return calendar.isDate(date, inSameDayAs: self)
    }
    
    func format(_ format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func format(formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
    
    static func parse(_ content: String, format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: content)
    }
    
    func add(component: Foundation.Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func diffDays(to: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: to, to:self ).day ?? 0
    }
    
    func weekOfYear(firstWeekday: WeekDay = .sunday) -> Int {
        var calendar: Foundation.Calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = firstWeekday.rawValue
        calendar.minimumDaysInFirstWeek = 7
        let components = calendar.dateComponents(Set([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.weekday, Calendar.Component.weekOfYear, Calendar.Component.yearForWeekOfYear]), from: self)
        if components.year != components.yearForWeekOfYear {
            return 1
        }
        guard let firstYearDay = calendar.date(from: DateComponents(calendar: calendar, timeZone: calendar.timeZone, era: nil, year: components.year, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)) else {
            return 0
        }
        let firstYearDayComponents = calendar.dateComponents(Set([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.weekday, Calendar.Component.weekOfYear, Calendar.Component.yearForWeekOfYear]), from: firstYearDay)
        return (components.weekOfYear ?? 0) + ((firstYearDayComponents.weekday == firstWeekday.rawValue) ? 0 : 1)
    }
    
    func chineseDate() -> String {
        var year = "\(self.component(component: .year))"
        year = year.replacingOccurrences(of: "0", with: "零")
        year = year.replacingOccurrences(of: "1", with: "一")
        year = year.replacingOccurrences(of: "2", with: "二")
        year = year.replacingOccurrences(of: "3", with: "三")
        year = year.replacingOccurrences(of: "4", with: "四")
        year = year.replacingOccurrences(of: "5", with: "五")
        year = year.replacingOccurrences(of: "6", with: "六")
        year = year.replacingOccurrences(of: "7", with: "七")
        year = year.replacingOccurrences(of: "8", with: "八")
        year = year.replacingOccurrences(of: "9", with: "九")
        let month = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"][self.component(component: .month) - 1]
        let day = [
            "一", "二", "三", "四", "五", "六", "七", "八", "九", "十",
            "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
            "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十",
            "卅一", "十二", "十二"][self.component(component: .day) - 1]
        return "\(year)年\(month)月\(day)日"
    }
}
