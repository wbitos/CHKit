//
//  WeekDay.swift
//  blueeyed
//
//  Created by 王义平 on 2019/12/20.
//  Copyright © 2019 Overnight. All rights reserved.
//

import UIKit

public enum WeekDay: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    public func name() -> String {
        let names: [String] = ["日", "一", "二", "三", "四", "五", "六"]
        return names[self.rawValue - 1]
    }
}
