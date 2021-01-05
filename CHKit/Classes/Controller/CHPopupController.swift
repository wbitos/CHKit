//
//  CHPopupController.swift
//  blueeyed
//
//  Created by 王义平 on 2020/6/21.
//  Copyright © 2020 Overnight. All rights reserved.
//

import UIKit

open class CHPopupController<T: UIView>: CHViewController {
    public enum Position {
        case top
        case bottom
        case center
        case left
        case right
    }
    
    open var popupView: T? = nil

    open var complete: Closures.Action<CHPopupController<T>>? = nil
    open var cancel: Closures.Action<CHPopupController<T>>? = nil
    open var action: Closures.Action<CHPopupController<T>>? = nil

    open var window: UIWindow? = { () -> UIWindow? in
        if #available(iOS 13.0, *) {
            guard let scene = UIApplication.shared.connectedScenes.filter({ (scence) -> Bool in
                return scence.activationState == .foregroundActive
            }).map({ (scence) -> UIWindowScene? in
                return scence as? UIWindowScene
            }).compactMap({$0}).first  else {
                return nil
            }
            let win = UIWindow(windowScene: scene)
            win.windowLevel = UIWindow.Level.alert
            win.backgroundColor = UIColor.clear
            win.isHidden = false
            return win
        }
        let win = UIWindow(frame: UIScreen.main.bounds)
        win.windowLevel = UIWindow.Level.alert
        win.backgroundColor = UIColor.clear
        win.isHidden = false
        return win
    }()
    
    open var topCoverView: UIControl? = UIControl()
    
    open var coverView = UIButton(type: .custom)
    open var popupContainerView = UIView(frame: .zero)

    open var position: Position = .bottom
    open var offset: CGFloat = 0.0
    open var popViewSize: CGSize? = nil
    
    public init(popupView: T? = nil) {
        super.init()
        self.popupView = popupView
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func preparePopupView() {
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        let offset = self.offset

        if let topCoverView = self.topCoverView {
            topCoverView.backgroundColor = UIColor.clear
            self.view.addSubview(topCoverView)
            topCoverView.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.height.equalTo(offset)
            }
            
            topCoverView.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { [weak self](btn) in
                guard let strong = self else {
                    return
                }
                strong.cancel?(strong)
                strong.hide(animated: true)
            }
        }

        
        self.view.addSubview(self.coverView)
        self.coverView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        self.coverView.snp.makeConstraints { (maker) in
            if let topCoverView = self.topCoverView {
                maker.top.equalTo(topCoverView.snp.bottom)
            }
            else {
                maker.top.equalToSuperview()
            }
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        self.coverView.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { [weak self](btn) in
            guard let strong = self else {
                return
            }
            strong.cancel?(strong)
            strong.hide(animated: true)
        }
        
        
        self.view.layoutIfNeeded()
        self.preparePopupView()

        
        if let popupView = self.popupView {
            let size = self.popViewSize ?? popupView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            if self.position == .bottom {
                self.view.addSubview(self.popupContainerView)
                self.popupContainerView.addSubview(popupView)

                popupView.snp.makeConstraints { [weak self](maker) in
                    guard let strong = self else {
                        return
                    }
//                    maker.bottom.equalToSuperview().offset(size.height)
                    maker.top.equalToSuperview()
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    maker.height.equalTo(size.height)
//                    maker.bottom.equalToSuperview()
                    // maker.bottom.equalTo(strong.view.safeAreaLayoutGuide.snp.bottom)
                }
                
                self.popupContainerView.snp.makeConstraints { [weak self](maker) in
                    guard let strong = self else {
                        return
                    }
                    maker.top.equalTo(strong.view.snp.bottom)
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    maker.height.equalTo(size.height)
                }
            }
            else if self.position == .top {
                self.view.addSubview(popupView)
                popupView.snp.makeConstraints { (maker) in
                    maker.top.equalToSuperview().offset(-1 * size.height)
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    maker.height.equalTo(size.height)
                }
            }
            else if self.position == .center {
                self.view.addSubview(popupView)
                popupView.snp.makeConstraints { (maker) in
                    maker.height.equalTo(size.height)
                    maker.width.equalTo(size.width)
                    maker.center.equalToSuperview()
                }
            }
            
            if let topCoverView = self.topCoverView {
                self.view.bringSubviewToFront(topCoverView)
            }
            self.popupView?.layoutIfNeeded()
            self.popupContainerView.layoutIfNeeded()
            self.view.layoutIfNeeded()

            self.popupView?.alpha = 0.0
            UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.popupView?.alpha = 0.2
            }) { (finished) in
                
                UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.popupView?.alpha = 1.0

                    if self.position == .bottom {
                        
                        self.popupContainerView.snp.remakeConstraints { [weak self](maker) in
                            guard let strong = self else {
                                return
                            }
                            maker.bottom.equalToSuperview()
                            maker.leading.equalToSuperview()
                            maker.trailing.equalToSuperview()
                        }
                        popupView.snp.remakeConstraints { [weak self](maker) in
                            guard let strong = self else {
                                return
                            }
                            maker.top.equalToSuperview()
//                            maker.bottom.equalToSuperview()
                            maker.leading.equalToSuperview()
                            maker.trailing.equalToSuperview()
                            maker.height.equalTo(size.height)
                            maker.bottom.equalTo(strong.view.safeAreaLayoutGuide.snp.bottom)
                        }
                    }
                    else if self.position == .top {
                        popupView.snp.remakeConstraints { (maker) in
                            maker.top.equalToSuperview().offset(offset)
                            maker.leading.equalToSuperview()
                            maker.trailing.equalToSuperview()
                            maker.height.equalTo(size.height)
                        }
                    }
                    self.popupView?.layoutIfNeeded()
                    self.popupContainerView.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                }) { (f) in
                    self.complete?(self)
                }
            }
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

    open func show(animated: Bool, complete: Closures.Action<CHPopupController<T>>?) {
        self.window?.rootViewController = self
        self.window?.makeKeyAndVisible()
        self.complete = complete
    }
    
    open func hide(animated: Bool, complete: Closures.Action<Bool>? = nil) {
        guard let popupView = self.popupView else {
            self.window?.resignKey()
            self.view.alpha = 1.0
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.view.alpha = 0.0
            }) { (finished) in
                self.window?.isHidden = true
                self.window?.rootViewController = nil
                self.window = nil
                complete?(finished)
            }
            return
        }
        let size = popupView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

//        self.popupView?.alpha = 1.0
//        let offset = self.offset
        self.coverView.alpha = 1.0

        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut], animations: {
//            self.popupView?.alpha = 0.5
            self.coverView.alpha = 0.2

            if self.position == .bottom {
                self.popupView?.snp.remakeConstraints { [weak self](maker) in
                    guard let strong = self else {
                        return
                    }
//                    maker.bottom.equalToSuperview().offset(size.height)
                    maker.top.equalToSuperview()
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    maker.height.equalTo(size.height)
                    maker.bottom.equalToSuperview()
                    // maker.bottom.equalTo(strong.view.safeAreaLayoutGuide.snp.bottom)
                }
                
                self.popupContainerView.snp.remakeConstraints { [weak self](maker) in
                    guard let strong = self else {
                        return
                    }
                    maker.top.equalTo(strong.view.snp.bottom)
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                }
            }
            else if self.position == .top {
                popupView.snp.remakeConstraints { (maker) in
                    maker.top.equalToSuperview().offset(-1 * size.height)
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    maker.height.equalTo(size.height)
                }
            }

            self.view.layoutIfNeeded()
        }) { (f) in
            UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveEaseInOut], animations: {
//                self.popupView?.alpha = 0.0
                self.coverView.alpha = 0.0
            }) { (finished) in
                self.window?.isHidden = true
                self.window?.rootViewController = nil
                self.window = nil
                
                complete?(finished)
            }
        }
    }
}
