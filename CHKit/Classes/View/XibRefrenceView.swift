//
//  XibRefrenceView.swift
//  chihuahua
//
//  Created by wbitos on 2019/2/11.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import SnapKit

class XibRefrenceView: UIView {
    @IBInspectable var refrencenibname: String = ""
    var refrence: UIView? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let refrence = Bundle(for: XibRefrenceView.self).loadNibNamed(self.refrencenibname, owner: nil, options: nil)?.first as? UIView {
            self.addSubview(refrence)
            refrence.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
            self.refrence = refrence
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
