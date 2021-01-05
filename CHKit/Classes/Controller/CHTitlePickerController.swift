//
//  CHTitlePickerController.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/24.
//

import UIKit

open class CHTitlePickerController: CHPopupController<CHTitlePickerView> {
    open var datasource: [[String]] = []
    open var selectedIndexs: [Int]? = nil
    
    open var onConfirm: Closures.Action<[Int]?>? = nil

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.popupView?.footerView.cancelButton.reactive.controlEvents(.touchUpInside).observeValues({ (button) in
            
        })
        
        self.popupView?.footerView.confirmButton.reactive.controlEvents(.touchUpInside).observeValues({ [weak self](button) in
            guard let strong = self else {
                return
            }
            strong.onConfirm?(strong.popupView?.selectedIndexes)
            strong.hide(animated: true)
        })
    }
    
    open override func preparePopupView() {
        super.preparePopupView()
        self.popupView = CHTitlePickerView(frame: .zero)
        let indexes = self.selectedIndexs ?? self.datasource.map({ (titles) -> Int in
            return 0
        })
        self.popupView?.set(datasource: self.datasource, selectedIndexes: indexes)
        self.popupView?.backgroundColor = UIColor.dynamicColor(light: .white, dark: .white)
        self.popupContainerView.backgroundColor = UIColor.dynamicColor(light: .white, dark: .white)
        self.popViewSize = CGSize(width: UIScreen.main.bounds.size.width, height: 50 + 50 + 180)
        self.position = .bottom
    }
}
