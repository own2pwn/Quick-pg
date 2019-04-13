//
//  ClosureBox<T>.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

public struct ClosureBox<T> {
    let closure: T
    let uuid: String = UUID().uuidString
}

extension ClosureBox: Hashable {
    public static func == (lhs: ClosureBox<T>, rhs: ClosureBox<T>) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    public func hash(into hasher: inout Hasher) {
        return uuid.hash(into: &hasher)
    }
}
