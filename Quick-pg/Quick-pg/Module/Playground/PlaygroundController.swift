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

final class PlaygroundDockView: EPShadowCardView {
    // MARK: - Views

    private lazy var interactiveView: ViewProducer = {
        let view = ViewProducer(in: self)
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

    // MARK: - Setup

    override func setup() {
        interactiveView.onProduced
            .listen(action: handle)

        interactiveView.onInteractionEnded
            .listen(action: handleEnd)
    }

    // MARK: - Helpers

    private func handle(produced view: InteractiveView) {
        container.addSubview(view)

        let centerInContainer = convert(contentView.bounds.center, to: container)
        view.center = centerInContainer
    }

    private func handleEnd(with view: InteractiveView) {
        let mappedRect: CGRect = convert(contentView.frame, to: container)
        let insideDock: Bool = mappedRect.intersects(view.frame)

        if insideDock {
            return kill(view: view)
        }

        UIView.animate {
            view.setShadow(Shadow.clear)
        }
    }

    private func kill(view: UIView) {
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.calculationModeCubic, .allowUserInteraction], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.6, animations: {
                view.alpha = 0
            })

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
                view.transform = CGAffineTransform.identity.scaledBy(x: 0.3, y: 0.3)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.9, animations: {
                view.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
            })

        }) { _ in
            view.removeFromSuperview()
        }
    }

    // MARK: - Layout

    override func layout() {
        interactiveView.pin
            .height(84)
            .width(88)
            .center()
    }
}

final class PlaygroundController: EYController {
    // MARK: - Views

    private let clickyView: __InteractiveView = {
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

    private let popupView: PopupView = {
        let view = PopupView()

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
            .height(108)
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

public extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

public extension CGPoint {
    func adjusted(by point: CGPoint) -> CGPoint {
        return CGPoint(x: x + point.x, y: y + point.y)
    }

    mutating func adjust(by point: CGPoint) {
        x = x + point.x
        y = y + point.y
    }
}
