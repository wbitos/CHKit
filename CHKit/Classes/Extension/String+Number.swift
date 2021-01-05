//
//  String+Number.swift
//  CHKit
//
//  Created by 王义平 on 2020/12/10.
//

import UIKit

public extension String {
    func trimTailZero() -> String {
        if let _ = self.firstIndex(of: ".") {
            let trimed = "#\(self.replacingOccurrences(of: ".", with: "#."))".trimmingCharacters(in: CharacterSet(charactersIn: "0."))
            return trimed.replacingOccurrences(of: "#", with: "")
        }
        return self
    }
}
