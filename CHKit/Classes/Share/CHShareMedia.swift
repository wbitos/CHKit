//
//  CHShareMedia.swift
//  CHKit
//
//  Created by 王义平 on 2020/10/29.
//

import UIKit

open class CHShareMedia: NSObject {
    public enum MediaType: String {
        case webpage = "webpage"
        case image = "image"
        case video = "video"
        case text = "text"
    }
    
    open func prepare(complete: Closures.Action<CHShareMedia?>) {
        complete(self)
    }
}

public protocol ImageConvertable {
    func get(callback: Closures.Action<UIImage?>)
}

extension String: ImageConvertable {
    public func get(callback: (UIImage?) -> Void) {
        if self.hasPrefix("http") {
            guard let url = URL(string: self) else {
                callback(nil)
                return
            }
            url.get(callback: callback)
            return
        }
        
        guard let imageBase64String = self.split(separator: ",").last else {
            callback(nil)
            return
        }
        guard let imageData = Data(base64Encoded: String(imageBase64String)) else {
            callback(nil)
            return
        }
        imageData.get(callback: callback)
    }
}

extension URL: ImageConvertable {
    public func get(callback: (UIImage?) -> Void) {
        
    }
}

extension UIImage: ImageConvertable {
    public func get(callback: (UIImage?) -> Void) {
        callback(self)
    }
}

extension Data: ImageConvertable {
    public func get(callback: (UIImage?) -> Void) {
        callback(UIImage(data: self))
    }
}

open class TextMedia: CHShareMedia {
    open var text: String = ""
}

open class ImageMedia: CHShareMedia {
    open var text: String = ""
    open var image: ImageConvertable? = nil
    
    open override func prepare(complete: Closures.Action<ImageMedia?>) {
        guard let image = self.image else {
            complete(nil)
            return
        }
        image.get(callback: { [weak self](img) in
            guard let strong = self else {
                return
            }
            
            let m = ImageMedia()
            m.image = img
            m.text = strong.text
            complete(m)
        })
    }
}

open class WebpageMedia: CHShareMedia {
    open var text: String = ""
    open var desc: String = ""
    open var url: String = ""
    open var thumbnail: ImageConvertable? = nil
    
    open override func prepare(complete: Closures.Action<WebpageMedia?>) {
        guard let thumbnail = self.thumbnail else {
            complete(nil)
            return
        }
        thumbnail.get(callback: { [weak self](img) in
            guard let strong = self else {
                return
            }
            
            let m = WebpageMedia()
            m.thumbnail = img
            m.text = strong.text
            m.desc = strong.desc
            m.url = strong.url
            complete(m)
        })
    }
}
