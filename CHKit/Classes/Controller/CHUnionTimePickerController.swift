//
//  CHUnionTimePickerController.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/23.
//

import UIKit

open class CHUnionTimePickerController: CHPopupController<CHUnionDatePickerView> {
    open var selectedDate: Date = Date()
    
    open var onConfirm: Closures.Action<Date?>? = nil

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.popupView?.select(date: self.selectedDate, animated: true)
        self.popupView?.footerView.cancelButton.reactive.controlEvents(.touchUpInside).observeValues({ (button) in
            
        })
        
        self.popupView?.footerView.confirmButton.reactive.controlEvents(.touchUpInside).observeValues({ [weak self](button) in
            guard let strong = self else {
                return
            }
            
            strong.onConfirm?(strong.popupView?.selectedDate)
            strong.hide(animated: true)
        })
    }
    
    open override func preparePopupView() {
        super.preparePopupView()
        self.popupView = CHUnionDatePickerView(frame: .zero)
        self.popupView?.backgroundColor = UIColor.dynamicColor(light: .white, dark: .white)
        self.popupContainerView.backgroundColor = UIColor.dynamicColor(light: .white, dark: .white)
        self.popViewSize = CGSize(width: UIScreen.main.bounds.size.width, height: 50 + 50 + 180)
        self.position = .bottom
    }
}
