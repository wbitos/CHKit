//
//  CHShareController.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/29.
//

import UIKit

open class CHShareController: CHPopupController<CHShareSheetView> {
    
    open func prepareSummaryView() -> CHView? {
        let summaryView = SummaryView(frame: .zero)
        return summaryView
    }
    
    open class SummaryView: CHView {
        open lazy var imageView: UIImageView = { () -> UIImageView in
            let imageView = UIImageView(frame: .zero)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        open override func prepare() {
            
            self.addSubview(self.imageView)
            self.imageView.snp.remakeConstraints { (maker) in
                maker.leading.equalToSuperview().offset(40)
                maker.trailing.equalToSuperview().offset(-40)
                maker.bottom.equalToSuperview().offset(-40)
                maker.top.greaterThanOrEqualToSuperview().offset(40)
            }
            
        }
    }
    
    open lazy var summaryView: CHView? = nil
    
    open var media: CHShareMedia? = nil
    open var callback: Closures.Action<Bool>? = nil
    open var willShareAction: Closures.ActionCallback<CHShareController, CHShareMedia?>? = nil
    
    open lazy var platforms: [CHSharePlatform] = { () ->  [CHSharePlatform] in
        return CHShareService.shared.all()
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.popupView?.footerView.cancelButton.reactive.controlEvents(.touchUpInside).observeValues({ [weak self](button) in
            guard let strong = self else {
                return
            }
            strong.callback?(false)
            strong.hide(animated: true)
        })
        
        if let popupView = self.popupView {
            if let summaryView = self.prepareSummaryView() {
                summaryView.isHidden = true
                summaryView.backgroundColor = .clear
                self.coverView.addSubview(summaryView)
                summaryView.snp.makeConstraints { [weak self](maker) in
                    guard let strong = self else {
                        return
                    }
//                    maker.top.equalToSuperview().offset(40)
                    maker.leading.equalToSuperview().offset(40)
                    maker.trailing.equalToSuperview().offset(-40)
                    maker.bottom.equalTo(popupView.snp.top).offset(-90)
                }
                self.summaryView = summaryView
                self.summaryView?.clipsToBounds = true
                
                if let imageSummaryView = summaryView as? SummaryView {
                    if let imageMedia = self.media as? ImageMedia {
                        imageMedia.prepare { [weak self](media) in
                            guard let strong = self else {
                                return
                            }
                            if let image = media?.image as? UIImage {
                                imageSummaryView.imageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    open override func preparePopupView() {
        super.preparePopupView()
        self.popupView = CHShareSheetView(frame: .zero)
        
        let platformViews: [CHSharePlatformView] = self.platforms.map { (p) -> CHSharePlatformView in
            let platformView = CHSharePlatformView(frame: .zero)
            platformView.platform = p
            platformView.reactive.controlEvents(.touchUpInside).observeValues { [weak self](vw) in
                guard let strong = self else {
                    return
                }
                guard let platform = vw.platform else {
                    return
                }
                
                strong.share(platform: platform)
                strong.hide(animated: true)
            }
            return platformView
        }
        self.popupView?.platformViews = platformViews
        self.popupContainerView.layer.cornerRadius = 12
        self.popupContainerView.clipsToBounds = true
        self.popupContainerView.backgroundColor = UIColor.dynamicColor(light: 0xf5f5f5, dark: 0xf5f5f5)
        self.popViewSize = CGSize(width: UIScreen.main.bounds.size.width, height: 190)
        self.position = .bottom
    }
    
    open func share(platform: CHSharePlatform) {
        guard let meida = self.media else {
            return
        }
        
        guard let beforeAction = self.willShareAction else {
            platform.share(media: meida, complete: self.callback)
            return
        }
        beforeAction(self, { [weak self](media) -> Void in
            guard let strong = self else {
                return
            }
            guard let m = media else {
                return
            }
            platform.share(media: m, complete: strong.callback)
        })
    }
}
