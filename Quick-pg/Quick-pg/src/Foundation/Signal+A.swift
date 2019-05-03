//
//  Signal+A.swift
//  Quick-pg
//
//  Created by Evgeniy on 03/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

final class SignalA {
    // MARK: - Members

    private static var observers: [AnyObserver] = []

    // MARK: - Interface

    static func tell<T>(_ sender: T, kind _: T.Type = T.self) {
        let matched: [Observer<T>] = matchingObservers()

        matched.forEach { (observer: Observer<T>) in
            observer.action(sender)
        }
    }

    static func listen<T>(all kindOf: T.Type = T.self, handler: @escaping (T) -> Void) {
        let newObserver: Observer<T> = Observer<T>(
            listens: kindOf, action: handler
        )
        observers.append(newObserver)
    }

    // MARK: - Helpers

    private static func matchingObservers<T>() -> [Observer<T>] {
        return observers.compactMap { $0 as? Observer<T> }
    }

    // MARK: - Init

    private init() {}
}

private protocol AnyObserver {}

private struct Observer<T>: AnyObserver {
    let listens: T.Type
    let action: (T) -> Void
}
