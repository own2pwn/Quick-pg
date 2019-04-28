//
//  Signal.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

typealias ActionBlock<T> = (T) -> Void

protocol SignalProducer: class {
    associatedtype PU

    func tell<PU>(_ arg: PU)
}

protocol SignalConsumer: class {
    associatedtype CU

    func listen<CU>(action: @escaping ActionBlock<CU>)
}

final class Signal<T>: SignalProducer, SignalConsumer {
    typealias PU = T

    typealias CU = T

    // MARK: - Types

    // MARK: - Members

    private var actions: [ActionBlock<T>]

    // MARK: - Interface

    func listen<CU>(action: @escaping (CU) -> Void) {
        actions.append(unsafeBitCast(action, to: ActionBlock<T>.self))
    }

    func tell<PU>(_ arg: PU) {
        actions.forEach { (action: (T) -> Void) in
            if let casted = arg as? T {
                action(casted)
            }
        }
    }

    // MARK: - Init

    init() {
        actions = []
    }
}

extension Signal where T == Void {
    func tell() {
        tell(())
    }
}
