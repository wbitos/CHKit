//
//  CHTableViewEntryCell.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/4.
//

import UIKit
import SDWebImage

open class CHTableViewEntryCell: CHTableViewCell {

    open lazy var titleLabel: UILabel = {() -> UILabel in
        let label = UILabel(frame: .zero)
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    open lazy var infoLabel: UILabel = {() -> UILabel in
        let label = UILabel(frame: .zero)
        label.backgroundColor = .clear
        label.textColor = UIColor.dynamicColor(light: 0x6a6a6a, dark: 0x6a6a6a)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    open lazy var indicatorView: UIImageView = {() -> UIImageView in
        let imageView = UIImageView(frame: .zero)
        imageView.image = CHBundle.shared.image(named: "entry_indicator")
        return imageView
    }()
    
    open lazy var seperator: PhysicalOnePixelSeperatorVertical = { () -> PhysicalOnePixelSeperatorVertical in
        let seperator = PhysicalOnePixelSeperatorVertical(frame: .zero)
        seperator.backgroundColor = UIColor.dynamicColor(light: 0xf8f8f8, dark: 0xf8f8f8)
        return seperator
    }()
    
    open lazy var thumbnailView: UIImageView = {() -> UIImageView in
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = UIColor.dynamicColor(light: 0xf2f2f2, dark: 0xf2f2f2)
        return imageView
    }()
    
    open var entry: Entry? = nil {
        didSet {
            self.titleLabel.text = self.entry?.title
            self.infoLabel.text = self.entry?.desc
            
            if let url = self.entry?.imageUrl, url.count > 0 {
                self.thumbnailView.isHidden = false
                self.thumbnailView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .retryFailed, completed: nil)
            }
            else {
                self.thumbnailView.isHidden = true
            }
        }
    }

    open override func prepare() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(18)
            maker.centerY.equalToSuperview()
            maker.width.greaterThanOrEqualTo(160)
        }
        
        self.contentView.addSubview(self.indicatorView)
        self.indicatorView.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-18)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(5.5)
            maker.height.equalTo(10)
        }
        
        self.thumbnailView.layer.cornerRadius = 30
        self.thumbnailView.clipsToBounds = true
        self.thumbnailView.isHidden = true
        self.contentView.addSubview(self.thumbnailView)
        self.thumbnailView.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.leading.greaterThanOrEqualTo(strong.titleLabel.snp.trailing).offset(20)
            maker.trailing.equalTo(strong.indicatorView.snp.leading).offset(-10)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(60)
            maker.height.equalTo(60)
        }
        
        self.contentView.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.leading.greaterThanOrEqualTo(strong.titleLabel.snp.trailing).offset(20)
            maker.trailing.equalTo(strong.indicatorView.snp.leading).offset(-10)
            maker.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(self.seperator)
        self.seperator.snp.makeConstraints { [weak self](maker) in
            guard let strong = self else {
                return
            }
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1.0/UIScreen.main.scale)
            maker.trailing.equalToSuperview().offset(-18)
            maker.leading.equalToSuperview().offset(18)
        }
    }
}
