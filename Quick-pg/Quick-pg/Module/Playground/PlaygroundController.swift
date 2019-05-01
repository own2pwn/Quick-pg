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
        UIView.serial(animation: .scaleDown(self))
    }

    private func onInteractionEnded() {
        UIView.serial(animation: .resetScale(self))
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

