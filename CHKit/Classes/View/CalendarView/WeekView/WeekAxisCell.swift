//
//  WeekAxisCell.swift
//  Coco
//
//  Created by wbitos on 2019/8/29.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit
import SnapKit

open class WeekAxisCell: TimeAxisCell<WeekView> {
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        //self.monthView.selectedWeek = -1
    }
}
