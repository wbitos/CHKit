//
//  CHProgressHud.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/18.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import JGProgressHUD

class CHProgressHud: JGProgressHUD {
    init(toast: String) {
        super.init(style: .dark)
        self.textLabel.text = toast
    }
    
    override init(style: JGProgressHUDStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @discardableResult
    static func show(toast: String, inView view: UIView? = nil) -> CHProgressHud? {
        guard let parentView: UIView = view ?? (UIApplication.shared.delegate?.window as? UIView) else {
            return nil
        }
        
        let hud = CHProgressHud(style: .dark)
        hud.position = .bottomCenter
        hud.interactionType = .blockNoTouches
        hud.indicatorView = nil
        hud.textLabel.text = toast
        hud.show(in: parentView, animated: true)
        hud.dismiss(afterDelay: 2.5, animated: true)
        return hud
    }
}
