//
//  CHCustomButton.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/17.
//

import UIKit

open class CHCustomButton: CHControl {
    public var label: UILabel = { () -> UILabel in
        let label = UILabel(frame: .zero)
        return label
    }()
    
    public var imageView: UIImageView = { () -> UIImageView in
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    open override func prepare() {
        
    }
}
