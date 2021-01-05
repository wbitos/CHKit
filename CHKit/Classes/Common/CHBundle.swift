//
//  CHBundle.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/21.
//

import UIKit

open class CHBundle: NSObject {
    public static var shared = CHBundle()
    public lazy var bundle: Bundle? = { () -> Bundle? in
        let classBundle = Bundle(for: CHBundle.self)
        guard let url = classBundle.url(forResource: "CHKit", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: url)
    }()
    
    public func image(named: String) -> UIImage? {
        return UIImage(named: named, in: self.bundle, compatibleWith: nil)
    }
}
