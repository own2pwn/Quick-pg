//
//  ViewProducer.swift
//  Quick-pg
//
//  Created by Evgeniy on 02/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import EPUIKit
import UIKit

final class ViewProducer: EPView, IViewProducer {
    // MARK: - Interface

    lazy var onProduced = SignalM<InteractiveView, ViewProducer>()

    lazy var onInteractionEnded = SignalM<InteractiveView, ViewProducer>()

    // MARK: - Members

    private var state: State = .none

    private var producedView: InteractiveView?

    // MARK: - Touches

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        update(with: .possible)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        let moveDelta: CGPoint = self.moveDelta(from: touches)
        update(with: .moved(moveDelta))
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        update(with: .none)
    }

    override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        update(with: .none)
    }

    // MARK: - Update

    private func update(with updated: State) {
        act(for: updated)
        guard state.differs(from: updated) else {
            return
        }
        // print("\(state) -> \(updated)")
        animate(updated)

        state = updated
    }

    // MARK: - Action handling

    private func act(for updated: State) {
        let action: Action = self.action(for: updated)
        handle(action)
    }

    private func handle(_ action: Action) {
        switch action {
        case .produce:
            produce()
        case let .adjust(point):
            adjust(by: point)
        case .finish:
            finish()
        }
    }

    // MARK: - Animation handling

    private func animate(_ updated: State) {
        let animation: Animation = self.animation(for: updated)
        handle(animation)
    }

    private func handle(_ animation: Animation) {
        switch animation {
        case .reset:
            UIView.serial(animation: .reset(self))
        case .scaleDown:
            UIView.serial(animation: .scaleDown(self))
        case .none:
            break
        }
    }

    // MARK: - Action

    private func produce() {
        let view: InteractiveView = make()
        onProduced.send(view, sender: self)

        animate(produced: view)
    }

    private func adjust(by delta: CGPoint) {
        producedView?.adjustOrigin(by: delta)
    }

    private func finish() {
        assert(producedView != nil)

        onInteractionEnded.send(producedView.unsafelyUnwrapped, sender: self)
        producedView = nil
    }

    // MARK: - Logic

    private func action(for updated: State) -> Action {
        switch updated {
        case .possible:
            return .produce
        case let .moved(point):
            return .adjust(point)
        case .none:
            return .finish
        }
    }

    private func animation(for updated: State) -> Animation {
        switch (state, updated) {
        case (.none, .possible):
            return .scaleDown

        case (.none, .none):
            return .none

        case (_, .none):
            return .reset

        default:
            return .none
        }
    }

    // MARK: - Helpers

    private func moveDelta(from touches: Set<UITouch>) -> CGPoint {
        guard let touch = touches.first else {
            return .zero
        }

        return moveDelta(touch: touch)
    }

    private func moveDelta(touch: UITouch) -> CGPoint {
        let current: CGPoint = touch.location(in: container)
        let previous: CGPoint = touch.previousLocation(in: container)

        return current - previous
    }

    private func make() -> InteractiveView {
        let view: InteractiveView = InteractiveView(frame: bounds)
        view.backgroundColor = #colorLiteral(red: 0.9309999943, green: 0.9462000728, blue: 0.9499999881, alpha: 1)
        view.contentView.layer.cornerRadius = layer.cornerRadius
        view.shadow = InteractiveView.shadow

        producedView = view
        return view
    }

    private func animate(produced view: UIView) {
        let newCenterDelta: CGPoint = CGPoint(x: 24, y: -24)
        view.alpha = 0

        UIView.animate {
            view.alpha = 1
            view.frame.origin.adjust(by: newCenterDelta)
        }
    }

    // MARK: - Members

    private let container: UIView

    // MARK: - Init

    init(in container: UIView) {
        self.container = container
        super.init(frame: .zero)
    }
}

// MARK: - Private

private extension UIView {
    func copy(of other: UIView) {
        bounds = other.bounds
        backgroundColor = other.backgroundColor
        layer.cornerRadius = other.layer.cornerRadius
    }

    func adjustOrigin(by delta: CGPoint) {
        frame.origin += delta
    }
}

// MARK: - Types

private enum State {
    case none
    case possible

    /// dx move
    case moved(CGPoint)
    // case interacting
}

private enum Action {
    case finish
    case produce
    case adjust(CGPoint)
}

private enum Animation {
    case none
    case reset
    case scaleDown
}

private extension State {
    func equals(to rhs: State) -> Bool {
        let lhs: State = self
        switch (lhs, rhs) {
        case (.none, .none),
             (.possible, .possible),
             (.moved, .moved): return true
        default:
            return false
        }
    }

    func differs(from rhs: State) -> Bool {
        let lhs: State = self
        switch (lhs, rhs) {
        case (.none, .none),
             (.possible, .possible),
             (.moved, .moved): return false
        default:
            return true
        }
    }
}
