//
//  Memory.swift
//  Quick-pg
//
//  Created by Evgeniy on 01/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

public enum Memory {
    public static func ptr<T: AnyObject>(of object: T) -> UInt {
        return unsafeBitCast(object, to: UInt.self)
    }
}
