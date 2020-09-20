//
//  Date+Moment.swift
//  chihuahua
//
//  Created by wbitos on 2019/5/30.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

extension Date {
    func moment() -> String {
        let cal = Calendar.current
        
        let now = Date()
        let intval = now.timeIntervalSince(self)
        
        if cal.isDateInToday(self) {
            let hour = Int(intval / 3600.0)
            if hour > 0 {
                return "\(hour)小时前"
            }
            let minute = Int(intval / 60.0)
            if minute > 0 {
                return "\(minute)分钟前"
            }
            return "刚刚"
        }
        else if cal.isDateInYesterday(self) {
            return "昨天"
        }
        
        let days = Int(intval / 86400.0)
        if days > 365 {
            let components = cal.dateComponents(Set<Calendar.Component>([.year]), from: self, to: now)
            return "\(components.year ?? 0)年前"
        }
        else if days > 30 {
            let components = cal.dateComponents(Set<Calendar.Component>([.month]), from: self, to: now)
            return "\(components.month ?? 0)月前"
        }
        return "\(days)天前"
    }
}
