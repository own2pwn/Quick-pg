//
//  RightSidePanelViewModel.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import UIKit

enum InteractionType {
    case setBackground(hex: String)
    case setCorner(radius: String)
}

protocol IRightSidePanelViewModel: SidePanelViewModel {
    // func setBackground(color: UIColor)
    func handle(interaction: InteractionType)
}

final class RightSidePanelViewModel: QuickInteractible, IRightSidePanelViewModel {
    // MARK: - Members

    private weak var chosenView: QuickView?

    // MARK: - Interface

    func setBackground(color _: UIColor) {}

    func handle(interaction: InteractionType) {
        switch interaction {
        case let .setBackground(hex: color):
            set(background: color)
        case let .setCorner(radius: value):
            set(corner: value)
        }
    }

    // MARK: - Input

    func interact(with view: QuickView) {
        chosenView = view

        let models = makeModels(for: view.viewType)
    }

    // MARK: - Helpers

    private func makeModels(for quickType: QuickViewType) {
        _ = quickType
        // print("interacting with: \(quickType)")
    }

    // MARK: - Actions

    private func set(background hex: String) {
        if let color = UIColor(hexStr: hex) {
            chosenView?.apply(action: .setBackground(color))
        }
    }

    private func set(corner radius: String) {
        if let intValue = Int(radius) {
            chosenView?.apply(action: .setCorner(CGFloat(intValue)))
        }
    }
}

enum QuickViewAction {
    case setBackground(_ color: UIColor)
    case setCorner(_ radius: CGFloat)
}

extension QuickView {
    func apply(action: QuickViewAction) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.7)

        switch action {
        case let .setBackground(color):
            setBackground(color: color)
        case let .setCorner(radius):
            setCorner(radius: radius)
        }

        UIView.commitAnimations()
    }

    // MARK: - Actions

    private func setBackground(color: UIColor) {
        nativeView.backgroundColor = color
    }

    private func setCorner(radius: CGFloat) {
        nativeView.layer.cornerRadius = radius
    }

    // MARK: - Helpers

    @inlinable
    var nativeView: UIView {
        return unsafeDowncast(self, to: UIView.self)
    }

    @inlinable
    func nativeView<T: UIView>(of type: T.Type = T.self) -> T {
        return unsafeDowncast(self, to: type)
    }
}
