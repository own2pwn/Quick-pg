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

    private var state: State = .none

    private var producedView: EPView?

    // MARK: Overrides

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(with: .possible)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let moveDelta: CGPoint = self.moveDelta(from: touches)
        update(with: .moved(moveDelta))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(with: .none)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(with: .none)
    }

    // MARK: - Logic

    private func update(with updated: State) {
        guard updated != state else {
            return
        }
        let action: Action = self.action(for: updated)
        handle(action)

//        let current: State = state
//        state = updated
//
//        if current == .none, updated == .possible {
//            return onInteractionPossible()
//        }
//
//        if updated == .none {
//            return onInteractionEnded()
//        }
    }

    private func handle(_ action: Action) {
        switch action {
        case .produce:
            produce()
        case let .adjust(point):
            adjust(by: point)
        default:
            break
        }
    }

    // MARK: - Actions

    private func produce() {
        let newView: EPView = EPView()
        newView.backgroundColor = backgroundColor
        newView.layer.cornerRadius = layer.cornerRadius
        newView.bounds = bounds

        // todo extension for cgpoint from cgrect
        // newView.frame.origin = CGPoint(x: bounds.midX, y: bounds.midY)

        let boundsCenter: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let thisViewOrigin = convert(boundsCenter, to: container)
        newView.frame.origin = thisViewOrigin

        container.addSubview(newView)
        producedView = newView
    }

    private func adjust(by delta: CGPoint) {
        //print("=> \(point)")
        producedView?.frame.origin += delta
    }

    // MARK: - Helpers

    private func action(for updated: State) -> Action {
        switch updated {
        case .possible:
            return .produce
        case let .moved(point):
            return .adjust(point)
        case .none:
            return .none
        }
    }

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

    // MARK: - State

    private enum State: Hashable {
        case none
        case possible

        /// dx move
        case moved(CGPoint)
        // case interacting

        static func == (lhs: State, rhs: State) -> Bool {
            return stateEquals(lhs, to: rhs)
        }
    }

    private enum Action {
        case none
        case produce
        case adjust(CGPoint)
    }

    private enum Animation {
        case reset
        case scaleDown
    }

    // MARK: - Observers

    private func onInteractionPossible() {
        UIView.serial(animation: .scaleDown(self))
    }

    private func onInteractionEnded() {
        UIView.serial(animation: .resetScale(self))
    }

    // MARK: - Members

    private let container: UIView

    // MARK: - Init

    init(in container: UIView) {
        self.container = container
        super.init(frame: .zero)
    }

    // MARK: - Comparable

    private static func stateEquals(_ lhs: State, to rhs: State) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.none, _):
            return false

        case (.possible, .possible):
            return true
        case (.possible, _):
            return false

        case let (.moved(lp), .moved(rp)):
            return lp == rp
        case (.moved, _):
            return false
        }
    }
}

final class PlaygroundDockView: EPShadowCardView {
    // MARK: - Views

    private lazy var interactiveView: ViewProducer = {
        let view = ViewProducer(in: container)
        view.backgroundColor = #colorLiteral(red: 0.436576277, green: 0.8080026507, blue: 0.5136813521, alpha: 1)
        view.layer.cornerRadius = 12

        return view
    }()

    override var views: [UIView] {
        return [interactiveView]
    }

    // MARK: - Members

    private let container: UIView

    // MARK: - Init

    init(in container: UIView) {
        self.container = container
        super.init(frame: .zero)
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

    private lazy var dockView: PlaygroundDockView = {
        let dock = PlaygroundDockView(in: view)
        dock.backgroundColor = #colorLiteral(red: 0.5135422349, green: 0.7635512948, blue: 0.9127233028, alpha: 1)
        dock.backgroundColor = #colorLiteral(red: 0.508185029, green: 0.5382546782, blue: 0.5591002107, alpha: 1)
        dock.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2352941176, blue: 0.3137254902, alpha: 1)

        let shadowOffset: CGSize = CGSize(
            width: 0, height: 1
        )

        dock.shadow = Shadow(
            color: #colorLiteral(red: 0.1499999464, green: 0.1499999464, blue: 0.1499999464, alpha: 1), radius: 8,
            offset: shadowOffset, opacity: 0.7
        )

        dock.cornerRadius = 32

        return dock
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

public extension CGPoint {
    static prefix func - (operand: CGPoint) -> CGPoint {
        return CGPoint.zero - operand
    }
}

public extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y
        )
    }

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }
}

public extension CGPoint {
    static func += (i: inout CGPoint, operand: CGPoint) {
        i.x = i.x + operand.x
        i.y = i.y + operand.y
    }

    static func -= (i: inout CGPoint, operand: CGPoint) {
        i.x = i.x - operand.x
        i.y = i.y - operand.y
    }
}

public protocol CanBeAbsolute {
    associatedtype ValueType

    var absoluteValue: ValueType { get }
}

public func abs<T: CanBeAbsolute>(_ x: T) -> T {
    return unsafeBitCast(x.absoluteValue, to: T.self)
}

extension CGPoint: CanBeAbsolute {
    public var absoluteValue: CGPoint {
        return CGPoint(x: abs(x), y: abs(y))
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        x.hash(into: &hasher)
        y.hash(into: &hasher)
    }
}
