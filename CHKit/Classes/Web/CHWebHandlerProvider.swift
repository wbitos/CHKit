//
//  CHWebHandlerProvider.swift
//  CHKit
//
//  Created by 王义平 on 2020/11/18.
//

import UIKit
import WebViewJavascriptBridge

open class CHWebHandlerProvider: NSObject {
    open weak var webViewController: CHWebController?
    open weak var bridge: WebViewJavascriptBridge?
    
    public static var factory: Closures.Default<CHWebHandlerProvider>? = nil
    
    public override init() {
        super.init()
    }
    
    init(bridge:WebViewJavascriptBridge, webViewController: CHWebController? = nil) {
        super.init()
        self.bridge = bridge
        self.webViewController = webViewController
        self.prepare()
    }
    
    open func prepare() {
        
    }
    
    deinit {
        NSLog("\(NSStringFromClass(self.classForCoder))")
    }
}
