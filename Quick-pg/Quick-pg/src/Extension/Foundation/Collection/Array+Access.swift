//
//  Array+Access.swift
//  Quick-pg
//
//  Created by Evgeniy on 01/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

public extension Array {
    @inlinable
    mutating func takeFirst() -> Element? {
        guard count > 0 else {
            return nil
        }
        return remove(at: 0)
    }
}

// public extension Array {
//    @inlinable __consuming
//    func takeFirst(n: Int) -> SubSequence {
//        return dropFirst(n)
//    }
//
//    @inlinable __consuming
//    func takeFirst() -> SubSequence? {
//        guard count > 0 else {
//            return nil
//        }
//        return dropFirst()
//    }
// }
