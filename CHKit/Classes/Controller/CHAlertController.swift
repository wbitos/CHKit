//
//  CHAlertController.swift
//  blueeyed
//
//  Created by 王义平 on 2020/3/31.
//  Copyright © 2020 Overnight. All rights reserved.
//

import UIKit

class CHAlertController: UIViewController {
    @IBOutlet var alertView: UIView?
    var complete: Closures.Action<CHAlertController>? = nil

    var window: UIWindow? = { () -> UIWindow in
        let win = UIWindow(frame: UIScreen.main.bounds)
        win.windowLevel = UIWindow.Level.alert
        win.backgroundColor = UIColor.clear
        win.isHidden = false
        return win
    }()
    
    override func viewDidLoad() {
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

    func show(animated: Bool, complete:Closures.Action<CHAlertController>? = nil) {
        self.window?.rootViewController = self
        self.window?.makeKeyAndVisible()
        self.complete = complete
    }
    
    func hide(animated: Bool) {
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
    
    @IBAction func cancel(_ sender: Any) {
        self.hide(animated: true)
    }
}
