//
//  CHPickerController.swift
//  blueeyed
//
//  Created by 王义平 on 2019/12/20.
//  Copyright © 2019 Overnight. All rights reserved.
//

import UIKit

class CHPickerController<T: UIView>: CHViewController {
    var picker: T? = nil
    
    var complete:Closures.Action<Bool>?
    
    var coverView = UIButton(type: .custom)
    
    lazy var window: UIWindow? = { () -> UIWindow in
        let win = UIWindow(frame: UIScreen.main.bounds)
        win.windowLevel = .alert
        win.backgroundColor = UIColor.clear
        win.isHidden = false
        return win
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        
        self.view.addSubview(self.coverView)
        self.coverView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        self.coverView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.coverView.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { [weak self](btn) in
            guard let strong = self else {
                return
            }
            
            strong.hide(animated: true)
        }
        self.view.layoutIfNeeded()

        if let picker = self.picker {
            self.view.addSubview(picker)
            picker.snp.makeConstraints { (maker) in
                maker.bottom.equalToSuperview().offset(256)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.height.equalTo(256)
            }
            
            self.view.layoutIfNeeded()
            
            self.view.alpha = 0.0
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.view.alpha = 0.8
            }) { (finished) in
                
                UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.view.alpha = 1.0

                    picker.snp.remakeConstraints { (maker) in
                        maker.bottom.equalToSuperview()
                        maker.leading.equalToSuperview()
                        maker.trailing.equalToSuperview()
                        maker.height.equalTo(256)
                    }
                    
                    self.view.layoutIfNeeded()
                }) { (f) in
                    self.complete?(true)
                }
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func show(animated: Bool, complete:Closures.Action<Bool>?) {
        self.window?.rootViewController = self
        self.window?.makeKeyAndVisible()
        self.complete = complete
        
    }
    
    func hide(animated: Bool) {
        self.window?.resignKey()

        self.view.alpha = 1.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.view.alpha = 0.8
            self.picker?.snp.remakeConstraints { (maker) in
                maker.bottom.equalToSuperview().offset(256)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.height.equalTo(256)
            }
            self.view.layoutIfNeeded()
        }) { (f) in
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.view.alpha = 0.0
            }) { (finished) in
                self.window?.isHidden = true
                self.window?.rootViewController = nil
                self.window = nil
            }
        }
    }
}
