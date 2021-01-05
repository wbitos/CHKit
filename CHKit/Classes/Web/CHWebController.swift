//
//  CHWebController.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/16.
//

import UIKit
import WebKit
import WebViewJavascriptBridge

open class CHWebController: CHViewController {
    open class WKWebviewMessageProxy: NSObject, WKScriptMessageHandler {
        open weak var handler: WKScriptMessageHandler? = nil
        open weak var context: WKUserContentController? = nil
        open weak var webview: WKWebView? = nil
        
        open var processor: [String: Closures.ActionCallback<[String: Any]?, [String: Any]?>] = [:]
        
        open func start() {
            self.context?.removeScriptMessageHandler(forName: "native")
            self.context?.removeAllUserScripts()
            self.context?.add(self, name: "native")
        }
        
        open func stop() {
            self.context?.removeScriptMessageHandler(forName: "native")
            self.context?.removeAllUserScripts()
        }
        
        open func register(name: String, processor: Closures.ActionCallback<[String: Any]?, [String: Any]?>?) {
            self.processor[name] = processor
        }
        
        open func serialization(parameters: [String: Any]?) -> String {
            guard let data = try? JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted) else {
                return "{}"
            }
            guard let json = String(data: data, encoding: .utf8) else {
                return "{}"
            }
            return json.replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "\"", with: "\\\"")
                .replacingOccurrences(of: "\'", with: "\\\'")
                .replacingOccurrences(of: "\n", with: "\\n")
                .replacingOccurrences(of: "\r", with: "\\r")
        }
        
        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "native" {
                if let userinfo = message.body as? [String: Any] {
                    if let function = userinfo["function"] as? String {
                        let parameters = userinfo["parameters"] as? [String: Any]
                        if let processor = self.processor[function] {
                            processor(parameters, { [weak self](ret) in
                                guard let strong = self else {
                                    return
                                }
                                
                                if let callback = userinfo["callback"] as? String {
                                    let retStr = strong.serialization(parameters: ret ?? [:])
                                    DispatchQueue.main.async {
                                        message.webView?.evaluateJavaScript("window.wkbridge.flush('\(callback)', '\(retStr)')", completionHandler: { (r, error) in
                                            
                                        })
                                    }
                                }
                            })
                        }
                    }
                    
                }
            }
            self.handler?.userContentController(userContentController, didReceive: message)
        }
    }
    
    open class WebviewInterceptor: NSObject {
        open func handle(webView: WKWebView, context: Any? = nil, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> Bool {
            return false
        }
        
        open func handle(webView: WKWebView, context: Any? = nil, didFinish navigation: WKNavigation!) {

        }
        
        open func handle(webView: WKWebView, context: Any? = nil, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) -> Bool {
            return false
        }
        
        open func handle(webView: WKWebView, context: Any? = nil, didFail navigation: WKNavigation!, withError error: Error) {
        
        }
    }
    
    public static var processPool = WKProcessPool()

    open var initialUrl: String? = nil
    open var webview: WKWebView!
    open lazy var progressView: UIProgressView = {
        let progress = UIProgressView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.main.bounds.width, height: 2))
        progress.tintColor = UIColor(hex: 0xff5d34)
        progress.trackTintColor = UIColor.white
        return progress
    }()
    
    open weak var containerController: UIViewController? = nil
    
    open var proxy: WKWebviewMessageProxy? = nil
    open var bridge:WebViewJavascriptBridge? = nil
    
    open var handlerProvider: CHWebHandlerProvider? = nil

    open var interceptor: WebviewInterceptor = WebviewInterceptor()
    open var action: Closures.Action<[String: Any]>? = nil

    open var shareMedia: CHShareMedia? = nil {
        didSet {
            self.updateNavigationItem()
        }
    }
    
    open var observerTitle: Bool {
        return true
    }
    
    open var autoload: Bool {
        return true
    }
    
    open var originInteractivePopGestureRecognizerEnable: Bool?

    open func prepareWebView() -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        config.processPool = CHWebController.processPool
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.userContentController = WKUserContentController()
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypes(rawValue: 0)
        let webview = WKWebView(frame: .zero, configuration: config)
        webview.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never
        }
        webview.customUserAgent = CHWebUserAgentBuilder.shared.customUserAgent
        return webview
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false
        
        self.webview = self.prepareWebView()
        self.webview.uiDelegate = self
        self.webview.navigationDelegate = self
        
        //self.automaticallyAdjustsScrollViewInsets = false
        if self.webview.superview == nil {
            self.view.addSubview(self.webview)
            self.webview.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
        }
        
        let proxy = WKWebviewMessageProxy()
        proxy.webview = self.webview
        proxy.context = self.webview.configuration.userContentController
        proxy.handler = self
        proxy.start()
        
        self.proxy = proxy
        
        if let bridge = WebViewJavascriptBridge(forWebView: self.webview) {
            bridge.setWebViewDelegate(self)
            self.bridge = bridge
        }
        
        self.handlerProvider?.bridge = self.bridge
        self.handlerProvider?.webViewController = self
        self.handlerProvider?.prepare()
        
        self.view.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(2)
        }
        
        self.webview.reactive.signal(forKeyPath: "estimatedProgress").take(duringLifetimeOf: self).observeValues { [weak self](value) in
            guard let strong = self else {
                return
            }
            if let progress = value as? Float {
                strong.progressView.alpha = 1.0
                strong.progressView.setProgress(progress, animated: true)
                
                if progress >= 1.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                        strong.progressView.alpha = 0
                    }, completion: { (finish) in
                        strong.progressView.setProgress(0.0, animated: false)
                    })
                }
            }
        }
        
        if self.observerTitle {
            self.webview.reactive.signal(forKeyPath: "title").take(duringLifetimeOf: self).observeValues { [weak self](value) in
                guard let strong = self else {
                    return
                }
                if let title = value as? String {
                    strong.title = title
                }
            }
        }
        
        CHKitNotifications.webviewReload.signal().take(during: self.reactive.lifetime).observeValues { [weak self](notification) in
            guard let strong = self else {
                return
            }
            let exceptCurrent = (notification.userInfo?["exceptCurrent"]) as? Bool ?? false
            if exceptCurrent && (notification.object as? CHWebController) == strong {
                return
            }
            strong.reload()
        }
        
        if self.autoload {
            self.reload()
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.originInteractivePopGestureRecognizerEnable = self.navigationController?.interactivePopGestureRecognizer?.isEnabled
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.backEnabled {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let origin = self.originInteractivePopGestureRecognizerEnable {
            if self.navigationController?.interactivePopGestureRecognizer?.isEnabled != origin {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = origin
            }
        }
    }
    
    open override func reload(complete: Closures.Action<Bool>? = nil) {
        super.reload(complete: nil)
        if let urlStr = self.initialUrl {
            if let url = URL(string: urlStr) {
                self.webview.load(URLRequest(url: url))
            }
        }
        complete?(true)
    }

    open func reloadCurrent(complete: Closures.Action<Bool>? = nil) {
        if let url = self.webview.url {
            self.webview.load(URLRequest(url: url))
        }
        complete?(true)
    }
    
    deinit {
//        self.handlerProvider?.removeAllInterceptors()
        self.proxy?.stop()
    }

    open func enableRefresh() {
        self.webview.scrollView.setRefresh { [weak self]() -> Void in
            guard let strong = self else {
                return
            }
            
            if let url = strong.webview.url {
                strong.webview.reload()
            }
            else {
                strong.reload(complete: nil)
            }
            strong.webview.scrollView.mj_header?.endRefreshing()
        }
    }
    
    open func disableRefresh() {
        self.webview.scrollView.disableRefresh()
    }
    
    open var backEnabled: Bool = true {
        didSet {
            self.updateNavigationItem()
        }
    }
    
    open var enableLeftNavigationItems: Bool = true {
        didSet {
            self.updateNavigationItem()
        }
    }
    
    open func goBackOrClose(_ sender: Any?) {
        if self.webview.canGoBack {
            self.webview.goBack()
        }
        else {
            super.back(nil)
        }
    }
    
    open override func back(_ sender: Any?) {
        self.goBackOrClose(sender)
    }
    
    @IBAction func close(_ sender: Any?) {
        super.back(sender)
    }
    
//    func hook(action: String, handler: String, identifier: String, userInfo: [String: Any]) -> AspectToken? {
//        let selector = Selector(action)
//        if let token = try? self.hook(selector: selector, strategy: .instead, block: { [weak self](info, sender: Any) in
//            guard let strong = self else {
//                return
//            }
//            strong.bridge?.callHandler(handler, data: ["identifier": identifier], responseCallback: { (response) in
//                NSLog("response:\(String(describing: response))")
//            })
//        }) {
//            return token
//        }
//        return nil
//    }
    
    func updateNavigationItem() {
        var leftItems: [UIBarButtonItem] = []
        if self.enableLeftNavigationItems {
            if self.backEnabled {
                leftItems.append(UIBarButtonItem(customView: self.backButton))
                
                if self.webview.canGoBack {
                    leftItems.append(UIBarButtonItem(customView: self.closeButton))
                }
            }
            else {
                leftItems.append(UIBarButtonItem(customView: self.closeButton))
            }
        }
        self.navigationItem.leftBarButtonItems = leftItems
        
        var rightItems: [UIBarButtonItem] = []

        if let _ = self.shareMedia {
            self.rightButton.setImage(CHBundle.shared.image(named: "bar_share"), for: .normal)
            rightItems.append(UIBarButtonItem(customView: self.rightButton))
        }
        
        self.navigationItem.rightBarButtonItems = rightItems
    }
    
}

extension CHWebController: WKNavigationDelegate, WKUIDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.observerTitle {
            self.title = webView.title
        }
        self.updateNavigationItem()
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if self.interceptor.handle(webView: webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler) {
            return
        }
        if let url = navigationAction.request.url {
            if url.absoluteString.contains("apps.apple.com") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly:true], completionHandler: nil)
                    decisionHandler(.cancel)
                    return
                }
            }
            if let scheme = url.scheme {
                if !scheme.hasPrefix("http") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly:false], completionHandler: nil)
                        decisionHandler(.cancel)
                        return
                    }
                }
            }
        }
        self.updateNavigationItem()
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if self.interceptor.handle(webView: webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler) {
            return
        }
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    
    }
}

extension CHWebController: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
