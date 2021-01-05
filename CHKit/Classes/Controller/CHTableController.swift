//
//  CHTableController.swift
//  chihuahua
//
//  Created by wbitos on 2018/11/12.
//  Copyright © 2018 wbitos. All rights reserved.
//

import UIKit

open class CHTableController: CHViewController {
    open lazy var tableView: UITableView = { () -> UITableView in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorStyle = .none
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
