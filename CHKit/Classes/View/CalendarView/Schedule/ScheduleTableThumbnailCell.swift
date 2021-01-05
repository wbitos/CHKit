//
//  ScheduleTableThumbnailCell.swift
//  Coco
//
//  Created by suyu on 2019/9/3.
//  Copyright © 2019 365rili.com. All rights reserved.
//

import UIKit

open class ScheduleTableThumbnailCell: UITableViewCell {
    open var titleLabel: UILabel = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.prepare()
    }
    
    open func prepare() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
