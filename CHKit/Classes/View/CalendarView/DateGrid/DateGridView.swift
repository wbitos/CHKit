//
//  DateGridView.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/29.
//

import UIKit

open class DateGridView: CHView {

    open class DateView: CHView {
        open var dayLabel: UILabel = { () -> UILabel in
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 24, weight: .light)
            label.textAlignment = .center
            label.textColor = UIColor.dynamicColor(light: 0x000000, dark: 0x000000)
            return label
        }()
        
        open var lunarLabel: UILabel = { () -> UILabel in
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            label.textColor = UIColor.dynamicColor(light: 0xaba29b, dark: 0xaba29b)
            label.textAlignment = .center
            
            return label
        }()
        
        open override func prepare() {
            self.addSubview(self.dayLabel)
            self.dayLabel.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview().offset(1)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
            
            self.addSubview(self.lunarLabel)
            self.lunarLabel.snp.makeConstraints { [weak self](maker) in
                guard let strong = self else {
                    return
                }
                maker.top.equalTo(strong.dayLabel.snp.bottom).offset(0)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
        }
    }
    
    open var dateView: DateView = { () -> DateView in
        let dateView = DateView(frame: .zero)
        return dateView
    }()
    
    open var workOrRestFlagLabel: UILabel = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "休"
        label.textColor = UIColor.dynamicColor(light: 0xbd4622, dark: 0xbd4622)
        return label
    }()
    
    open var data: CalendarViewDateDataSource? = nil {
        didSet {
            guard let ds = data else {
                return
            }
            
            self.dateView.dayLabel.text = "\(ds.solarDate.day())"
            self.dateView.lunarLabel.text = "\(ds.lunarDate.lunarDayDisplay() ?? "")"
            self.workOrRestFlagLabel.isHidden = true
            
            if let workOrRest = ds.statutoryHolidayStatus {
                self.workOrRestFlagLabel.isHidden = false
                self.workOrRestFlagLabel.text = (workOrRest == 1) ? "休" : "班"
                self.workOrRestFlagLabel.textColor = UIColor.dynamicColor(light: (workOrRest == 1) ? 0xbd4622 : 0x689a32, dark: (workOrRest == 1) ? 0xbd4622 : 0x689a32)
            }
            
            if let festival = ds.festivals.first {
                self.dateView.lunarLabel.text = "\(festival.name)"
            }
        }
    }
    
    open override func prepare() {
        self.addSubview(self.dateView)
        self.dateView.snp.makeConstraints { (maker) in
            maker.width.equalTo(45)
            maker.height.equalTo(45)
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
        
        self.workOrRestFlagLabel.isHidden = true
        self.addSubview(self.workOrRestFlagLabel)
        self.workOrRestFlagLabel.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.trailing.equalTo(strong.dateView.dayLabel.snp.leading).offset(7)
            maker.bottom.equalTo(strong.dateView.dayLabel.snp.top).offset(7)
        }
    }
}
