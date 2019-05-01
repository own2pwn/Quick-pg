//
//  AnimationQueue.swift
//  Quick-pg
//
//  Created by Evgeniy on 01/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import EPUIKit
import UIKit

final class AnimationQueue {
    // MARK: - Members

    private static var queue: [UInt: [Animation]] = [:]

    private static var states: [UInt: State] = [:]

    // MARK: - Interface

    static func run(_ animations: @escaping VoidBlock, on view: UIView) {
        let action: Action = self.action(for: view)

        switch action {
        case .animate:
            animate(animations, on: view)
        case .takeNext:
            animateNext(on: view)
        case .queue:
            queueAnimation(animations, for: view)
        }
    }

    // MARK: - Logic

    private static func animate(_ animations: @escaping VoidBlock, on view: UIView) {
        set(state: .animating, for: view)
        UIView.animate(withDuration: UIView.animationDuration, animations: animations) { completed in
            assert(completed)
            // print("=====>")

            self.set(state: .possible, for: view)
            self.animateNext(on: view)
        }
    }

    private static func animateNext(on view: UIView) {
        guard let next = nextAnimation(for: view) else {
            return
        }

        return animate(next.animations, on: view)
    }

    private static func queueAnimation(_ animations: @escaping VoidBlock, for view: UIView) {
        let newAnimation: Animation = Animation(
            view: view, animations: animations
        )
        append(newAnimation, for: view)
    }

    // MARK: - Logic

    private static func append(_ animation: Animation, for view: UIView) {
        let ptr: UInt = viewPtr(of: view)
        guard let existing: [Animation] = queue[ptr] else {
            return queue[ptr] = [animation]
        }

        var mutated = existing
        mutated.append(animation)
        queue[ptr] = mutated
    }

    private static func pendingAnimations(for view: UIView) -> [Animation] {
        let ptr: UInt = viewPtr(of: view)
        let pending: [Animation] = queue[ptr] ?? [Animation]()

        return pending
    }

    private static func state(for view: UIView) -> State {
        let ptr: UInt = viewPtr(of: view)
        let state: State = states[ptr] ?? .possible

        return state
    }

    private static func action(for view: UIView) -> Action {
        let state: State = self.state(for: view)
        let pending: [Animation] = pendingAnimations(for: view)
        let queueIsEmpty: Bool = pending.isEmpty

        return action(isQueueEmpty: queueIsEmpty, state: state)
    }

    private static func action(isQueueEmpty: Bool, state: State) -> Action {
        switch (isQueueEmpty, state) {
        case (true, .possible):
            return .animate

        case (true, .animating):
            return .queue

        case (false, .possible):
            return .takeNext

        case (false, .animating):
            return .queue
        }
    }

    // MARK: - Helpers

    private static func set(state: State, for view: UIView) {
        let ptr: UInt = viewPtr(of: view)
        states[ptr] = state
    }

    private static func nextAnimation(for view: UIView) -> Animation? {
        let ptr: UInt = viewPtr(of: view)
        let pending: [Animation] = pendingAnimations(for: view)
        guard !pending.isEmpty else {
            return nil
        }
        var mutated: [Animation] = pending
        let next: Animation? = mutated.takeFirst()

        queue[ptr] = mutated

        return next
    }

    private static func viewPtr(of view: UIView) -> UInt {
        return Memory.ptr(of: view)
    }

    // MARK: - State

    private enum State {
        // case none
        case possible
        case animating
    }

    private enum Action {
        case queue
        case animate
        case takeNext
    }

    struct Animation {
        let view: UIView
        let animations: VoidBlock
    }
}
