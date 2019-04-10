//
//  PlaygroundViewModel.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

protocol QuickInteractible: class {
    func interact(with view: QuickView)
}

protocol IPlaygroundViewModel: QuickInteractible {}

final class PlaygroundViewModel: IPlaygroundViewModel {
    // MARK: - Members

    private let sidePanelModel: IPlaygroundSidePanelViewModel

    // MARK: - Interface

    // MARK: - Input

    func interact(with view: QuickView) {
        sidePanelModel.interact(with: view)
    }

    // MARK: - Init

    init() {
        sidePanelModel = PlaygroundSidePanelViewModel()
    }
}

protocol IPlaygroundSidePanelViewModel: QuickInteractible {}

final class PlaygroundSidePanelViewModel: IPlaygroundSidePanelViewModel {
    // MARK: - Interface

    // MARK: - Input

    func interact(with view: QuickView) {
        let models = makeModels(for: view.viewType)
    }

    // MARK: - Helpers

    private func makeModels(for quickType: QuickViewType) {
        print("interacting with: \(quickType)")
    }
}
