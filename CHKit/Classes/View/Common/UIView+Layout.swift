//
//  LayoutView.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/11.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

public extension UIView {
    private struct LayoutViewAssociatedKeys {
        static var heightConstraitKey = "UIView.Layout.HeightConstrait"
        static var widthConstraitKey = "UIView.Layout.WidthConstrait"
        
        static var topConstraitKey = "UIView.Layout.TopConstrait"
        static var leftConstrait = "UIView.Layout.LeadingConstrait"
        static var rightConstrait = "UIView.Layout.TraillingConstrait"
        static var bottomConstraitKey = "UIView.Layout.BottomConstrait"
        
        static var centerXConstraitKey = "UIView.Layout.CenterXConstrait"
        static var centerYConstraitKey = "UIView.Layout.CenterYConstrait"
    }
    
    @IBOutlet var heightConstrait:NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &LayoutViewAssociatedKeys.heightConstraitKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            return objc_getAssociatedObject(self, &LayoutViewAssociatedKeys.heightConstraitKey) as? NSLayoutConstraint
        }
    }
    
    @IBOutlet var widthConstrait:NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &LayoutViewAssociatedKeys.widthConstraitKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            return objc_getAssociatedObject(self, &LayoutViewAssociatedKeys.widthConstraitKey) as? NSLayoutConstraint
        }
    }
    
    @IBOutlet var topConstrait:NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &LayoutViewAssociatedKeys.topConstraitKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            return objc_getAssociatedObject(self, &LayoutViewAssociatedKeys.topConstraitKey) as? NSLayoutConstraint
        }
    }
    
    @IBOutlet var leftConstrait:NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &LayoutViewAssociatedKeys.leftConstrait, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            return objc_getAssociatedObject(self, &LayoutViewAssociatedKeys.leftConstrait) as? NSLayoutConstraint
        }
    }
    
    @IBOutlet var rightConstrait:NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &LayoutViewAssociatedKeys.rightConstrait, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            return objc_getAssociatedObject(self, &LayoutViewAssociatedKeys.rightConstrait) as? NSLayoutConstraint
        }
    }
    
    @IBOutlet var bottomConstrait:NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &LayoutViewAssociatedKeys.bottomConstraitKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            return objc_getAssociatedObject(self, &LayoutViewAssociatedKeys.bottomConstraitKey) as? NSLayoutConstraint
        }
    }
    
    @IBOutlet var centerXConstrait:NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &LayoutViewAssociatedKeys.centerXConstraitKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            return objc_getAssociatedObject(self, &LayoutViewAssociatedKeys.centerXConstraitKey) as? NSLayoutConstraint
        }
    }
    
    @IBOutlet var centerYConstrait:NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &LayoutViewAssociatedKeys.centerYConstraitKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            return objc_getAssociatedObject(self, &LayoutViewAssociatedKeys.centerYConstraitKey) as? NSLayoutConstraint
        }
    }
}
