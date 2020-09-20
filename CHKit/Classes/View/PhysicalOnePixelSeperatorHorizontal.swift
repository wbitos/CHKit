//
//  PhysicalOnePixelSeperator.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/19.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

class PhysicalOnePixelSeperatorHorizontal: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.widthConstrait?.constant = 1.0 / UIScreen.main.scale
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
