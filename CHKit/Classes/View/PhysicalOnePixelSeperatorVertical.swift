//
//  PhysicalOnePixelView.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/18.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

class PhysicalOnePixelSeperatorVertical: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.heightConstrait?.constant = 1.0 / UIScreen.main.scale
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
