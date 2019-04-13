//
//  RightSidePanelViewModel.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import UIKit

protocol IRightSidePanelViewModel: SidePanelViewModel {
    func setBackground(color: UIColor)
}

final class RightSidePanelViewModel: QuickInteractible, IRightSidePanelViewModel {
    // MARK: - Members

    private weak var chosenView: QuickView?

    // MARK: - Interface

    func setBackground(color _: UIColor) {}

    // MARK: - Input

    func interact(with view: QuickView) {
        chosenView = view

        let models = makeModels(for: view.viewType)
    }

    // MARK: - Helpers

    private func makeModels(for quickType: QuickViewType) {
        print("interacting with: \(quickType)")
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
