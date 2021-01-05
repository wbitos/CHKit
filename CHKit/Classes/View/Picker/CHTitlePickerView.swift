//
//  CHTitlePickerView.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/24.
//

import UIKit

open class CHTitlePickerView: CHPickerView {
    open lazy var headerView: UIView = { () -> UIView in
        return UIView(frame: .zero)
    }()
    
    open lazy var pickerView: UIPickerView = { () -> UIPickerView in
        return UIPickerView(frame: .zero)
    }()
    
    open lazy var footerView: CHPickerView.FooterView = { () -> CHPickerView.FooterView in
        return CHPickerView.FooterView(frame: .zero)
    }()
    
    open var datasource: [[String]] = []
    open var selectedIndexes: [Int] = []

    open var onChange: Closures.Action<Date>? = nil
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepare()
    }
    
    public init() {
        super.init(frame: .zero)
        self.prepare()
    }
    
    open func prepare() {
        self.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(50)
            maker.top.equalToSuperview()
        }
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.addSubview(self.pickerView)
        self.pickerView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(180)
            maker.top.equalTo(strong.headerView.snp.bottom)
        }
        
        self.addSubview(self.footerView)
        self.footerView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(50)
            maker.top.equalTo(strong.pickerView.snp.bottom)
        }
    }
    
    open func set(datasource: [[String]], selectedIndexes: [Int]) {
        if datasource.count != selectedIndexes.count {
            return
        }
        self.datasource = datasource
        self.pickerView.reloadAllComponents()
        self.select(indexes: selectedIndexes, animated: true)
    }
    
    open func select(indexes: [Int], animated: Bool = true) {
        self.selectedIndexes = indexes
        for i in 0..<indexes.count {
            let row = indexes[i]
            self.pickerView.selectRow(row, inComponent: i, animated: true)
        }
    }
}

extension CHTitlePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.datasource.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.datasource[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.datasource[component][row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndexes[component] = row
    }
}
