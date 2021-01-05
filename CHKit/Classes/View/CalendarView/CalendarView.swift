//
//  CalendarView.swift
//  Coco
//
//  Created by 王义平 on 2020/4/25.
//  Copyright © 2020 365rili.com. All rights reserved.
//

import UIKit

open class CalendarView: UIView {
    open class Theme: NSObject {
        open class StateColor: NSObject {
            open var normal: UIColor = .black
            open var selected: UIColor = .white
            
            init(normal: UIColor = .black, selected: UIColor = .white) {
                super.init()
                self.normal = normal
                self.selected = selected
            }
            
            init(color: UIColor) {
                super.init()
                self.normal = color
                self.selected = color
            }
        }
        
        open class StateFont: NSObject {
            open var normal: UIFont = UIFont.systemFont(ofSize: 12)
            open var selected: UIFont = UIFont.systemFont(ofSize: 12)
            
            init(normal: UIFont = UIFont.systemFont(ofSize: 12), selected: UIFont = UIFont.systemFont(ofSize: 12)) {
                super.init()
                self.normal = normal
                self.selected = selected
            }
            
            init(font: UIFont) {
                super.init()
                self.normal = font
                self.selected = font
            }
        }
        
        open class Label: NSObject {
            open var textColor: StateColor = StateColor(normal: .black, selected: .white)
            open var backgroundColor: StateColor = StateColor(normal: .white, selected: .black)
            open var font: StateFont = StateFont(normal: UIFont.systemFont(ofSize: 12), selected: UIFont.systemFont(ofSize: 12))
            
            init(textColor: StateColor = StateColor(normal: .black, selected: .white), backgroundColor: StateColor = StateColor(normal: .white, selected: .black), font: StateFont = StateFont()) {
                super.init()
                self.textColor = textColor
                self.backgroundColor = backgroundColor
                self.font = font
            }
        }
        
        open class Grid: NSObject {
            open var backgroundColor: StateColor = StateColor(normal: .white, selected: .black)
            open var borderColor: StateColor? = nil
            
            init(backgroundColor: StateColor = StateColor(), borderColor: StateColor? = nil) {
                super.init()
                self.backgroundColor = backgroundColor
                self.borderColor = borderColor
            }
        }
        
        open var solarDate: Label = Label(
            textColor: StateColor(normal: .black, selected: .white),
            backgroundColor: StateColor(color: .clear),
            font: StateFont(font: UIFont.systemFont(ofSize: 24, weight: .light)))
        
        open var lunarDate: Label = Label(
            textColor: StateColor(normal: UIColor.dynamicColor(light: 0xaba29b, dark: 0xaba29b), selected: .white),
            backgroundColor: StateColor(color: .clear),
            font: StateFont(font: UIFont.systemFont(ofSize: 11, weight: .regular)))
        
        open var grid: Grid = Grid(backgroundColor: StateColor(normal: .clear, selected: UIColor.dynamicColor(light: 0xbd4622, dark: 0xbd4622)), borderColor: nil)
        open var todayGrid: Grid = Grid(backgroundColor: StateColor(normal: .clear, selected: UIColor.dynamicColor(light: 0xbd4622, dark: 0xbd4622)), borderColor: StateColor(normal: UIColor.dynamicColor(light: 0xbd4622, dark: 0xbd4622), selected: .clear))
    }
    
    open var theme: Theme = Theme()
    
    public enum Style: String {
        case `default` = "grid"
        case month = "month"
        case week = "week"
        case threeday = "threeday"
        case oneday = "oneday"
        case list = "list"

        func name() -> String {
            var name = "日历视图"
            switch self {
            case .month:
                name = "月视图"
            case .week:
                name = "周视图"
            case .threeday:
                name = "三日视图"
            case .oneday:
                name = "日视图"
            case .list:
                name = "列表视图"
            default:
                name = "日历视图"
            }
            return name
        }
        
        static func all() -> [Style] {
            return [.`default`, .month, .week, .threeday, .oneday, .list]
        }
        
        static func enabled() -> [Style] {
            return [.month, .week]
        }
        
        func isEnable() -> Bool {
            return Style.enabled().contains(self)
        }
    }
}

public protocol CalendarViewDelegate: NSObjectProtocol {
    func calendarView(_ calendarView: CalendarView?, shouldSelect date: Date) -> Bool
    func calendarView(_ calendarView: CalendarView?, didSelect date: Date)
    func calendarView(_ calendarView: CalendarView?, willShow date: Date)
    func calendarView(_ calendarView: CalendarView?, didShow date: Date)
    func calendarView(_ calendarView: CalendarView?, willHide date: Date)
    func calendarView(_ calendarView: CalendarView?, didHide date: Date)
    func calendarView(_ calendarView: CalendarView?, setToday show: Bool)
}
