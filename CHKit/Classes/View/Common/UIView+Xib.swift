//
//  UIView+Xib.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/20.
//

import UIKit

public protocol NibView {
    
}

public extension UIView {
    class func awake<T>(nibName: String) -> T? {
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first
        return view as? T
    }
    
    func export(afterScreenUpdate: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, UIScreen.main.scale)
        if self.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdate)
        }
        else if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
        }
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
}

public extension NibView where Self : UIView {
    static func load(name: String) -> Self? {
        return Bundle(for: Self.self).loadNibNamed(name, owner: nil, options: nil)?.first as? Self
    }
}
