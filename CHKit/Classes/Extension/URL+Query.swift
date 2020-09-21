//
//  URL+Query.swift
//  chihuahua
//
//  Created by wbitos on 2019/7/9.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

public extension URL {
    func parameters() -> [String: String] {
        var parameters = [String: String]()
        if let components = URLComponents(string: self.absoluteString) {
            if let queryItems = components.queryItems {
                
                queryItems.forEach({ (item) in
                    parameters[item.name] = item.value
                })
            }
        }
        return parameters
    }
}
