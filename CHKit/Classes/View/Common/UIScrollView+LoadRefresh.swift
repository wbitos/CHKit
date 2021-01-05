//
//  UIScrollView+LoadRefresh.swift
//  chihuahua
//
//  Created by wbitos on 2019/3/12.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import MJRefresh

public extension UIScrollView {
    func setRefresh(action: Closures.Default<Void>?) {
        let mj_header = MJRefreshNormalHeader {
            action?()
        }
        //MJRefreshGifHeader
        mj_header.mj_h = 40.0
        mj_header.stateLabel?.textColor = UIColor(hex: 0xe2e2e2)
        mj_header.lastUpdatedTimeLabel?.textColor = UIColor(hex: 0xe2e2e2)
        self.mj_header = mj_header
    }
    
    func disableRefresh() {
        self.mj_header = nil
    }
    
    func setLoadMore(action: Closures.Default<Void>?) {
        let mj_footer = MJRefreshAutoNormalFooter {
            action?()
        }
        mj_footer.stateLabel?.textColor = UIColor(hex: 0xe2e2e2)
        mj_footer.mj_h = 40.0
        self.mj_footer = mj_footer
    }
    
    func disableLoadMore() {
        self.mj_footer = nil
    }
}
