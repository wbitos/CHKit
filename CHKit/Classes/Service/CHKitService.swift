//
//  CHKitService.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/16.
//

import UIKit
import JLRoutes

open class CHKitService: NSObject {
    public static var shared = CHKitService()
    public let router = JLRoutes(forScheme: "chkit")

    #if DEBUG
    open var devops: Bool = true
    #else
    open var devops: Bool = false
    #endif
    
    open func setup() {
        self.setupRouters()
    }
    
    public func route(url: String, withParameters parameters: [String: Any]? = nil) {
        self.router.routeURL(URL(string: url), withParameters: parameters)
    }
    
    public func setupRouters() {
        self.router.addRoute("/webview/simple") { [weak self](userInfo) -> Bool in
            guard let strong = self else {
                return false
            }
            let controller = CHWebController()
            controller.initialUrl = userInfo["url"] as? String
            controller.action = userInfo["action"] as? Closures.Action<[String: Any]>
            controller.handlerProvider = (userInfo["handlerProvider"] as? CHWebHandlerProvider) ?? CHWebHandlerProvider.factory?()
            controller.hidesBottomBarWhenPushed = true
            strong.navigate(controller, navigation: userInfo["navigation"] as? UINavigationController)
            return true
        }
        
        self.router.addRoute("/share") { [weak self](userInfo) -> Bool in
            guard let strong = self else {
                return false
            }
            let controller = CHShareController()
            
            controller.media = userInfo["media"] as? CHShareMedia
            if let platforms = userInfo["platforms"] as? [CHSharePlatform] {
                controller.platforms = platforms
            }
            controller.show(animated: true) { (popup) in
                
            }
            return true
        }
        //

    }
    
    public func navigate(_ controller: UIViewController, navigation: UINavigationController? = nil) {
        let nav = navigation ?? UINavigationController.current()
        nav?.pushViewController(controller, animated: true)
    }
}
