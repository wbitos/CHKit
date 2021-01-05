//
//  CHTableViewCell.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/28.
//

import UIKit

open class CHTableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepare()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepare()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    open func prepare() {
        
    }
}
