//
//  Optional+Fallback.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

extension Optional {
    func or<T>(_ fallback: T) -> T {
        if let boxed = self as? T {
            return boxed
        }
        return fallback
    }
}

protocol Fallbacked {
    associatedtype T

    static var defaultValue: T { get }
}

func Fallback<T>(to value: T, _ optional: T?) -> T {
    if let boxed = optional {
        return boxed
    }
    return value
}

func Backed<T: Fallbacked>(_ optional: T?) -> T {
    if let boxed = optional {
        return boxed
    }
    return unsafeBitCast(T.defaultValue, to: T.self)
}

extension Int: Fallbacked {
    static let defaultValue: Int = 0
}

extension String: Fallbacked {
    static let defaultValue: String = ""
}
