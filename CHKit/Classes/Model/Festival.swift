//
//  Festival.swift
//  CHKit
//
//  Created by 王义平 on 2020/12/15.
//

import UIKit
import ObjectMapper
import LunarTerm

open class Festival: CHModel {
    public enum Kind: Int {
        case lunar = 0
        case term = 1
        case solar = 2
        case summer = 3
        case winter = 4
        case other = 5
    }
    
    open var kind: Kind = .other
    open var name: String = ""
    
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
        kind = (try? map.value("kind")) ?? .other
        name = (try? map.value("name")) ?? ""
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        kind <- map["kind"]
        name <- map["name"]
    }
    
    static let lunarMap: [String: String] = [
        "101": "春节",
        "115": "元宵节",
        "202": "龙抬头",
        "505": "端午节",
        "707": "七夕",
        "715": "中元节",
        "815": "中秋节",
        "909": "重阳节",
        "1208": "腊八节",
        "1223": "小年",
        "1230": "除夕",
    ]
    
    static let solarMap: [String: String] = [
        "101": "元旦",
        "214": "情人节",
        "308": "妇女节",
        "312": "植树节",
        "401": "愚人节",
        "501": "劳动节",
        "504": "青年节",
        "601": "儿童节",
        "701": "建党",
        "707": "抗战",
        "801": "建军节",
        "910": "教师节",
        "1001": "国庆节",
        "1031": "万圣节",
        "1111": "光棍节",
        "1224": "平安夜",
        "1225": "圣诞节",
    ]
    
    public static func lunar(for date: Date) -> Festival? {
        guard let lDate = LunarDate(solarDate: (date as NSDate).getGregorianDate()) else {
            return nil
        }
        var name: String? = nil
        let md = UInt32(lDate.month) * 100 + UInt32(lDate.day)
        if lDate.month == 12 && lDate.day == 29 {
            let layueDays = LunarDate.days(ofYear: lDate.year, inMonth: 12)
            if layueDays == 29 {
                name = "除夕"
            }
        }
        else {
            name = Festival.lunarMap["\(md)"]
        }
        
        guard let festivalName = name else {
            return nil
        }
        
        let festival = Festival()
        festival.kind = .lunar
        festival.name = festivalName
        return festival
    }
    
    public static func solar(for date: Date) -> Festival? {
        let gDate = (date as NSDate).getGregorianDate()
        let md = UInt32(gDate.month) * 100 + UInt32(gDate.day)
        var name = Festival.solarMap["\(md)"]
        if name != nil {
            if gDate.month == 5 && gDate.day > 7 && gDate.day < 15 {
                let weekday = date.weekday()
                if weekday == .sunday {
                    name = "母亲节"
                }
            }
            else if gDate.month == 6 && gDate.day > 14 && gDate.day < 22 {
                let weekday = date.weekday()
                if weekday == .sunday {
                    name = "父亲节"
                }
            }
            else if gDate.month == 11 && gDate.day > 21 && gDate.day < 29 {
                let weekday = date.weekday()
                if weekday == .thursday {
                    name = "感恩节"
                }
            }
        }
        
        guard let festivalName = name else {
            return nil
        }
        
        let festival = Festival()
        festival.kind = .solar
        festival.name = festivalName
        return festival
    }
}
