//
//  CalendarViewDateDataSource.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/24.
//

import UIKit
import LunarTerm

open class CalendarViewDateDataSource: NSObject {
    open var solarDate: Date = Date()
    open var lunarDate: LunarDate = LunarDate(solarDate: (Date() as NSDate).getGregorianDate())
    
    open var statutoryHolidayStatus: Int? = nil
    open var festivals: [Festival] = []
}
