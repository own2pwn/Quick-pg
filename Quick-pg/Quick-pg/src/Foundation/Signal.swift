//
//  Signal.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

typealias ActionBlock = () -> Void

protocol SignalProducer: class {
    func tell()
}

protocol SignalConsumer: class {
    func listen(action: @escaping ActionBlock)
}

final class Signal: SignalProducer, SignalConsumer {
    // MARK: - Members

    private var actions: [ActionBlock]

    // MARK: - Interface

    func listen(action: @escaping ActionBlock) {
        actions.append(action)
    }

    func tell() {
        actions.forEach(Signal.exec)
    }

    // MARK: - Helpers

    private static func exec(action: ActionBlock) {
        action()
    }

    // MARK: - Init

    init() {
        actions = []
    }
}
