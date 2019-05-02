//
//  GenericCache+T.swift
//  Quick-pg
//
//  Created by Evgeniy on 01/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

final class GenericCache<T: Hashable> {
    // MARK: - Types

    typealias CacheType = [T: Any]

    // MARK: - Members

    private static var cache: CacheType {
        get {
            let boxed: CacheType? = SharedCache.get(key: typeName)
            return boxed.unsafelyUnwrapped
        } set {
            SharedCache.set(newValue, for: typeName)
        }
    }

    // MARK: - Interface

    static func set(_ value: Any, for key: T) {
        cache[key] = value
    }

    static func get(key: T) -> Any? {
        return cache[key]
    }

    static func remove(key: T) -> Any? {
        return cache.removeValue(forKey: key)
    }

    // MARK: - Helpers

    private static var typeName: String {
        return "\(type(of: T.self))"
    }

    // MARK: - Init

    private init() {}
}
