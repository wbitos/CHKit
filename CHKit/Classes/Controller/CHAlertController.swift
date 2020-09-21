//
//  CHAlertController.swift
//  blueeyed
//
//  Created by 王义平 on 2020/3/31.
//  Copyright © 2020 Overnight. All rights reserved.
//

import UIKit

open class CHAlertController: UIViewController {
    @IBOutlet open var alertView: UIView?
    open var complete: Closures.Action<CHAlertController>? = nil

    open var window: UIWindow? = { () -> UIWindow in
        let win = UIWindow(frame: UIScreen.main.bounds)
        win.windowLevel = UIWindow.Level.alert
        win.backgroundColor = UIColor.clear
        win.isHidden = false
        return win
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.layoutIfNeeded()
        self.alertView?.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.alertView?.alpha = 1.0
            self.view.layoutIfNeeded()
        }) { (finished) in
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    open func show(animated: Bool, complete:Closures.Action<CHAlertController>? = nil) {
        self.window?.rootViewController = self
        self.window?.makeKeyAndVisible()
        self.complete = complete
    }
    
    open func hide(animated: Bool) {
        self.alertView?.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.alertView?.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { (finished) in
            
            self.window?.resignKey()
            self.window?.rootViewController = nil
            self.window?.isHidden = true
            self.window = nil
        }
    }
    
    @IBAction open func cancel(_ sender: Any) {
        self.hide(animated: true)
    }
}
