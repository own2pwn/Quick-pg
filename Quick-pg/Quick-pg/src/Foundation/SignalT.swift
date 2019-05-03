//
//  SignalT.swift
//  Quick-pg
//
//  Created by Evgeniy on 03/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

final class SignalT<T> {
    // MARK: - Types

    typealias PU = T

    typealias CU = T

    // MARK: - Members

    private var actions: [ActionBlock<T>]

    // MARK: - Interface

    func listen<CU>(action: @escaping (CU, T) -> Void) {
        actions.append(unsafeBitCast(action, to: ActionBlock<T>.self))
    }

    func tell<PU>(_ arg: PU) {
        guard let unboxed = arg as? T else {
            assertionFailure()
            return
        }

        actions.forEach { (action: (T) -> Void) in
            action(unboxed, self)
        }
    }

    // MARK: - Init

    init() {
        actions = []
    }
}

extension SignalT where T == Void {
    func tell() {
        tell(())
    }
}
