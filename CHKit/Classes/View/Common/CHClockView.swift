//
//  CHClockView.swift
//  CHKit
//
//  Created by 王义平 on 2022/5/24.
//

import UIKit

open class CHClockView: CHView {
    var date: Date?
    
    var color = UIColor.dynamicColor(light: 0x888e92, dark: 0x969696) {
        didSet {
            self.setNeedsDisplay()
            hourColorPoint.backgroundColor = color.cgColor
            minColorPoint.backgroundColor = color.cgColor
        }
    }
    let hourPoint = CALayer()
    let hourColorPoint = CALayer()
    let minPoint = CALayer()
    let minColorPoint = CALayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        hourPoint.backgroundColor = UIColor.clear.cgColor
        hourColorPoint.backgroundColor = UIColor.dynamicColor(light: 0x888e92, dark: 0x969696).cgColor
        hourColorPoint.allowsEdgeAntialiasing = true
        hourPoint.addSublayer(hourColorPoint)
        
        minPoint.backgroundColor = UIColor.clear.cgColor
        minColorPoint.backgroundColor = UIColor.dynamicColor(light: 0x888e92, dark: 0x969696).cgColor
        minColorPoint.allowsEdgeAntialiasing = true
        minPoint.addSublayer(minColorPoint)
        
        self.layer.addSublayer(hourPoint)
        self.layer.addSublayer(minPoint)
        
        let pi = CGFloat(Double.pi)
        hourPoint.transform = CATransform3DMakeRotation(pi, 0, 0, 1)
        minPoint.transform = CATransform3DMakeRotation(pi, 0, 0, 1)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        hourPoint.position = self.center
        minPoint.position = self.center
        hourPoint.bounds = CGRect(x: 0, y: 0, width: 1.5, height: 5.5)
        hourColorPoint.frame = CGRect(x: 0, y: 1, width: 1.5, height: 4.5)
        minPoint.bounds = CGRect(x: 0, y: 0, width: 1.5, height: 6)
        minColorPoint.frame = CGRect(x: 0, y: 1, width: 1.5, height: 5)
        
        hourPoint.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        minPoint.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    open override func draw(_ rect: CGRect) {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        color.set()
        context.setLineWidth(1);
        context.addEllipse(in: CGRect(x: self.center.x - 1.5, y: self.center.y - 1.5, width: 3, height: 3))
        context.strokePath()
        
        context.setLineWidth(1.5);
        context.addEllipse(in: CGRect(x: 2, y: 2, width: self.bounds.size.width - 4, height: self.bounds.size.height - 4))
        context.strokePath()
    }
    
    open func setDate(_ date: Date, animated: Bool) {
        let pi = CGFloat(Double.pi)
        self.date = date
        
        let hour = date.hour()
        let minute = date.minute()

        let hour4Twelve = hour >= 12 ? hour - 12 : hour
        
        var minAngle = CGFloat(Float(minute) / 60.0 * 360) * CGFloat(Double.pi / 180)
        var hourAngle = CGFloat(Float(hour4Twelve) / 12.0 * 360) + CGFloat(minAngle / 12.0) * CGFloat(Double.pi / 180)
        if minAngle == 0 {
            minAngle = pi * 2
        }
        if hourAngle == 0 {
            hourAngle = pi * 2
        }
        
        hourPoint.transform = CATransform3DMakeRotation(hourAngle + pi, 0, 0, 1)
        minPoint.transform = CATransform3DMakeRotation(minAngle + pi, 0, 0, 1)
        if animated {
            let duration = 0.8
            let hourAnimation = CABasicAnimation(keyPath: "transform.rotation")
            hourAnimation.duration = duration
            hourAnimation.fromValue = NSNumber(value: Float(Double.pi) as Float)
            hourAnimation.toValue = NSNumber(value: Float(hourAngle + pi) as Float)
            hourPoint.add(hourAnimation, forKey: "hourPointRotation")
            
            let minuteAnimation = CABasicAnimation(keyPath: "transform.rotation")
            minuteAnimation.duration = duration + 0.2
            minuteAnimation.fromValue = NSNumber(value: Float(Double.pi) as Float)
            minuteAnimation.toValue = NSNumber(value: Float(minAngle + pi) as Float)
            minPoint.add(minuteAnimation, forKey: "minutePointRotation")
        }
    }
}
