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
            chosenView?.apply(action: .background(color))
        }
    }
}

enum QuickViewAction {
    case background(UIColor)
}

extension QuickView {
    func apply(action: QuickViewAction) {
        switch action {
        case let .background(color):
            setBackground(color: color)
        }
    }

    // MARK: - Actions

    private func setBackground(color: UIColor) {
        nativeView.backgroundColor = color
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
