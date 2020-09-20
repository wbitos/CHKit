//
//  ReplicableLabel.swift
//  blueeyed
//
//  Created by 王义平 on 2020/4/1.
//  Copyright © 2020 Overnight. All rights reserved.
//

import UIKit

class ReplicableLabel: UILabel {
    @IBInspectable var replicableText: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenuAction(_:))))
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @IBAction func showMenuAction(_ sender: Any?) {
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        let copyItem = UIMenuItem(title: "复制", action: #selector(copyTextAction(_:)))
        menu.menuItems = [copyItem]
        menu.setTargetRect(self.bounds, in: self)
        menu.setMenuVisible(true, animated: true)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyTextAction(_:)) {
            return true
        }
        return false
    }
    
    @IBAction func copyTextAction(_ sender: Any?) {
        UIPasteboard.general.string = self.replicableText ?? (self.text ?? self.attributedText?.string)
    }
}
