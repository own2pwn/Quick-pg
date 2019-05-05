//
//  Signal+A.swift
//  Quick-pg
//
//  Created by Evgeniy on 03/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

private protocol AnyObserver {}

private struct Observer<T>: AnyObserver {
    let action: (T) -> Void
}

final class SignalA<T> {
    // MARK: - Types

    typealias EventBlock = (T) -> Void

    private typealias BoxedType = [AnyObserver]

    // MARK: - Interface

    static func tell(_ sender: T) {
        let matched: [Observer<T>] = matchingObservers()

        matched.forEach { (observer: Observer<T>) in
            observer.action(sender)
        }
    }

    static func listen(handler: @escaping EventBlock) {
        let newObserver: Observer<T> = Observer<T>(action: handler)
        observers.append(newObserver)
    }

    // MARK: - Helpers

    private static func matchingObservers<T>() -> [Observer<T>] {
        return observers.compactMap { $0 as? Observer<T> }
    }

    // MARK: - Members

    private static var observers: BoxedType {
        get {
            guard let unboxed = SharedCache.get(key: "\(type(of: self))") as? BoxedType else {
                return BoxedType()
            }

            return unboxed
        }
        set {
            SharedCache.set(newValue, for: "\(type(of: self))")
        }
    }

    // MARK: - Init

    private init() {}
}
