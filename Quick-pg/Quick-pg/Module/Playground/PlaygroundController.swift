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

final class PlaygroundViewHolder {}

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

    override var views: [UIView] {
        return [clickyView, sidePanelView, popupView]
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
    }

    private func layoutPopup() {
        // popupView.pin.width(view.frame.width / 3.2)
        popupView.layoutIfNeeded()
        popupView.pin.center()
    }
}
