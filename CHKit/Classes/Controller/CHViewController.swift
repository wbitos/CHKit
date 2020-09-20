//
//  CHViewController.swift
//  chihuahua
//
//  Created by wbitos on 2018/11/12.
//  Copyright © 2018 wbitos. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

public class CHViewController: UIViewController {
    lazy var backButton: UIButton = {
        let back = UIButton(type: .custom)
        back.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        back.setImage(UIImage(named: "navigation-back"), for: .normal)
        back.contentHorizontalAlignment = .left
        back.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (btn) in
            guard let strong = self else {
                return
            }
            strong.back(btn)
        }
        return back
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        closeButton.setImage(UIImage(named: "webview-close"), for: .normal)
        closeButton.contentHorizontalAlignment = .left
        closeButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (btn) in
            guard let strong = self else {
                return
            }
            strong.navigationController?.popViewController(animated: true)
        }
        return closeButton
    }()
    
    lazy var rightButton: UIButton = {
        let rightButton = UIButton(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.contentHorizontalAlignment = .right
        rightButton.setTitleColor(UIColor(hex: 0xff5d34), for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return rightButton
    }()
    
    var network: Bool {
        return false
    }
    
    var enableDevToast: Bool {
        return true
    }
    
    var viewDidLoadEvent: Closures.Action<CHViewController>? = nil
    var viewWillAppearEvent: Closures.Action<CHViewController>? = nil
    var viewDidAppearEvent: Closures.Action<CHViewController>? = nil
    var viewWillDisappearEvent: Closures.Action<CHViewController>? = nil
    var viewDidDisappearEvent: Closures.Action<CHViewController>? = nil

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if let nav = self.navigationController {
            nav.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor(hex: 0x000000)
            ]
            
            if nav.viewControllers.count > 1 {
                self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: self.backButton)]
            }
        }
        
       
        self.viewDidLoadEvent?(self)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearEvent?(self)
        super.viewWillAppear(animated)
        weak var weakSelf = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = weakSelf
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidAppearEvent?(self)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        self.viewWillDisappearEvent?(self)
        super.viewWillDisappear(animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewDidDisappearEvent?(self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func reload(complete: Closures.Action<Bool>? = nil) {
        
    }
    
    @IBAction @objc dynamic func back(_ sender: Any?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NSLog("\(NSStringFromClass(self.classForCoder)) deinit ...")
    }
}

extension CHViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self) {
            return (self.navigationController?.viewControllers.count ?? 0) > 1
        }
        return true
    }
}
