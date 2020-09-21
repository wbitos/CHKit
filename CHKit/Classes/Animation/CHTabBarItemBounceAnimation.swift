//
//  CHTabBarItemBounceAnimation.swift
//  blueeyed
//
//  Created by 王义平 on 2020/1/9.
//  Copyright © 2020 Overnight. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

open class CHTabBarItemBounceAnimation: RAMItemAnimation {
    @IBInspectable open var iconSelectedImage: UIImage?
    @IBInspectable open var iconNormalImage: UIImage?
    @IBInspectable open var textNormalColor: UIColor?

    /**
     Start animation, method call when UITabBarItem is selected

     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    open override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }

    /**
     Start animation, method call when UITabBarItem is unselected

     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     - parameter defaultTextColor: default UITabBarItem text color
     - parameter defaultIconColor: default UITabBarItem icon color
     */
    open override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        textLabel.textColor = self.textNormalColor

        icon.image = self.iconNormalImage
//        if let iconImage = icon.image {
//            let renderMode = defaultIconColor.cgColor.alpha == 0 ? UIImage.RenderingMode.alwaysOriginal :
//                UIImage.RenderingMode.alwaysTemplate
//            let renderImage = iconImage.withRenderingMode(renderMode)
//            icon.image = renderImage
//            icon.tintColor = defaultIconColor
//        }
    }

    /**
     Method call when TabBarController did load

     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    open override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        textLabel.textColor = textSelectedColor

        icon.image = self.iconSelectedImage

//        if let iconImage = icon.image {
//            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
//            icon.image = renderImage
//            icon.tintColor = iconSelectedColor
//        }
    }

    func playBounceAnimation(_ icon: UIImageView) {

        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic

        icon.layer.add(bounceAnimation, forKey: nil)
        
        icon.image = self.iconSelectedImage

//        if let iconImage = icon.image {
//            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
//            icon.image = renderImage
//            icon.tintColor = iconSelectedColor
//        }
    }
}
