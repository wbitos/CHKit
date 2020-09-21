//
//  CHNavigationController.swift
//  chihuahua
//
//  Created by wbitos on 2018/11/12.
//  Copyright © 2018 wbitos. All rights reserved.
//

import UIKit

open class CHNavigationController: UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
//        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
//        self.extendedLayoutIncludesOpaqueBars = false
//        self.modalPresentationCapturesStatusBarAppearance = false
    }
    

    open override var preferredStatusBarStyle : UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .lightContent
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
