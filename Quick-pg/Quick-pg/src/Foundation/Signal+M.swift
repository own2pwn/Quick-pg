//
//  Signal+M.swift
//  Quick-pg
//
//  Created by Evgeniy on 03/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

final class SignalM<T, U> {
    // MARK: - Types

    typealias EventBlock = (T, U) -> Void

    // MARK: - Members

    private var handlers: [EventBlock]

    // MARK: - Interface

    func listen(handler: @escaping EventBlock) {
        handlers.append(handler)
    }

    func send(_ arg: T, sender: U) {
        handlers.forEach { (handler: EventBlock) in
            handler(arg, sender)
        }
    }

    // MARK: - Init

    init() {
        handlers = []
    }
}

extension SignalM where T == Void {
    func send(_ sender: U) {
        send((), sender: sender)
    }
}
