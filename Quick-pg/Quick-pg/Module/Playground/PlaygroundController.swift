//
//  ViewController.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import CollectionKit
import EPUIKit
import PinLayout
import UIKit

public enum QuickViewType {
    case plain
}

final class ViewProducer: EPView {
    // MARK: - Touches

    // MARK: Members

    private var interactionState: InteractionState = .none

    // MARK: Overrides

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(with: .possible)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(with: .interacting)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(with: .none)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(with: .none)
    }

    // MARK: Private

    private enum InteractionState {
        case none
        case possible
        case interacting
    }

    private func update(with new: InteractionState) {
        guard new != interactionState else {
            return
        }

        let current: InteractionState = interactionState
        interactionState = new

        // print("\(current) -> \(new)")

        if current == .none, new == .possible {
            return onInteractionPossible()
        }

        if (current == .interacting || true), new == .none {
            return onInteractionEnded()
        }
    }

    private func onInteractionPossible() {
        UIView.animate {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.92, y: 0.92)
        }
    }

    private func onInteractionEnded() {
        UIView.animate {
            self.transform = CGAffineTransform.identity
        }
    }

    // MARK: -

}

final class PlaygroundDockView: EPShadowCardView {
    // MARK: - Views

    private let interactiveView: ViewProducer = {
        let view = ViewProducer()
        view.backgroundColor = #colorLiteral(red: 0.436576277, green: 0.8080026507, blue: 0.5136813521, alpha: 1)
        view.layer.cornerRadius = 12

        return view
    }()

    override var views: [UIView] {
        return [interactiveView]
    }

    // MARK: - Layout

    override func layout() {
        interactiveView.pin
            .height(100)
            .width(108)
            .center()
    }
}

final class PlaygroundController: EYController {
    // MARK: - Views

    private let clickyView: InteractiveView = {
        let view = SelectableView()
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.3568627451, blue: 0.4392156863, alpha: 1)
        view.layer.cornerRadius = 8

        return view
    }()

    private lazy var sidePanelView: RightSidePanelView = {
        let view = RightSidePanelView(
            viewModel: viewModel.rightSidePanelModel
        )
        view.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2352941176, blue: 0.3137254902, alpha: 1)
        view.layer.cornerRadius = 8

        return view
    }()

    private let popupView: InteractivePopup = {
        let view = InteractivePopup()

        return view
    }()

    private let dockView: PlaygroundDockView = {
        let view = PlaygroundDockView()
        view.backgroundColor = #colorLiteral(red: 0.5135422349, green: 0.7635512948, blue: 0.9127233028, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.508185029, green: 0.5382546782, blue: 0.5591002107, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2352941176, blue: 0.3137254902, alpha: 1)

        let shadowOffset: CGSize = CGSize(
            width: 0, height: 1
        )

        view.shadow = Shadow(
            color: #colorLiteral(red: 0.1499999464, green: 0.1499999464, blue: 0.1499999464, alpha: 1), radius: 8,
            offset: shadowOffset, opacity: 0.7
        )

        view.cornerRadius = 32

        return view
    }()

    override var views: [UIView] {
        return [dockView]
    }

    // MARK: - Members

    private let viewModel: IPlaygroundViewModel = {
        let model = PlaygroundViewModel()

        return model
    }()

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        view.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.9137254902, blue: 0.8078431373, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.5135422349, green: 0.7635512948, blue: 0.9127233028, alpha: 1)
    }

    override func setup() {
        clickyView.tapSignal.listen { (quick: QuickView) in
            self.viewModel.interact(with: quick)
        }
    }

    // MARK: - Layout

    override func layout() {
        clickyView.pin
            .height(216)
            .width(272)
            .center()
            .marginHorizontal(-64)

        sidePanelView.pin
            .vertically(64)
            .width(248)
            .end(view.pin.safeArea)
            .marginEnd(24)

        layoutPopup()
        layoutDock()
    }

    private func layoutPopup() {
        popupView.layoutIfNeeded()
        popupView.pin.center()
    }

    private func layoutDock() {
        dockView.pin
            .height(142)
            // .horizontally(56)
            .aspectRatio(4.8)
            .hCenter()
            .bottom(view.pin.safeArea)
            .marginBottom(24)
    }
}

public extension UIView {
    /// Animate changes to one or more views using `animationDuration` duration.
    static func animate(animations: @escaping () -> Void) {
        UIView.animate(withDuration: animationDuration, animations: animations)
    }

    /// Default duration when using extension methods.
    static var animationDuration: TimeInterval = 0.25
}

public extension UIView {
    func serial(animations: @escaping () -> Void, on view: UIView) {
        //UIView.animate(withDuration: animationDuration, animations: animations)
    }
}

final class ViewAnimationQueue {
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

        let ptr: UInt = viewPtr(of: view)

        guard let queued = queue[ptr], !queued.isEmpty else {
            return UIView.animate(animations: animations)
        }
    }

    // MARK: - Logic

    private static func animate(_ animations: @escaping VoidBlock, on view: UIView) {
        set(state: .animating, for: view)
        UIView.animate(withDuration: UIView.animationDuration, animations: animations) { completed in
            assert(completed)
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

    // MARK: - Helpers

    private static func append(_ animation: Animation, for view: UIView) {
        let ptr: UInt = viewPtr(of: view)
        guard let existing: [Animation] = queue[ptr] else {
            return queue[ptr] = [animation]
        }

        var mutated = existing
        mutated.append(animation)
        queue[ptr] = mutated
    }

    // MARK: - Logic

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
        let queueIsEmpty: Bool = !pending.isEmpty

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

public enum Memory {
    public static func ptr<T: AnyObject>(of object: T) -> UInt {
        return unsafeBitCast(object, to: UInt.self)
    }
}

public extension Array {
    @inlinable
    mutating func takeFirst() -> Element? {
        guard count > 0 else {
            return nil
        }
        return remove(at: 0)
    }
}

//public extension Array {
//    @inlinable __consuming
//    func takeFirst(n: Int) -> SubSequence {
//        return dropFirst(n)
//    }
//
//    @inlinable __consuming
//    func takeFirst() -> SubSequence? {
//        guard count > 0 else {
//            return nil
//        }
//        return dropFirst()
//    }
//}
