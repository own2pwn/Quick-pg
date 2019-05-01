//
//  SharedCache.swift
//  Quick-pg
//
//  Created by Evgeniy on 01/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

final class SharedCache {
    // MARK: - Members

    private static var cache: [String: Any] = [:]

    // MARK: - Interface

    static func set(_ value: Any, for key: String) {
        cache[key] = value
    }

    static func get(key: String) -> Any? {
        return cache[key]
    }

    static func get<T>(key: String) -> T? {
        return cache[key] as? T
    }

    static func remove(key: String) -> Any? {
        return cache.removeValue(forKey: key)
    }

    // MARK: - Init

    private init() {}
}
