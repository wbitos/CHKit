//
//  Collection+Chunk.swift
//  CHKit
//
//  Created by 王义平 on 2020/12/22.
//

import UIKit

public extension Collection {
    func chunked(by distance: Int) -> [[Element]] {var index = startIndex
        let iterator: AnyIterator<Array<Element>> = AnyIterator({
            let newIndex = self.index(index, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex
            defer { index = newIndex }
            let range = index ..< newIndex
            return index != self.endIndex ? Array(self[range]) : nil
        })
        return Array(iterator)
    }
}
