//
//  PlaygroundViewModel.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

protocol QuickInteractible: class {
    func interact(with view: QuickView)
}

protocol SidePanelViewModel: class {}

typealias RightSidePanelViewModelType = (QuickInteractible & IRightSidePanelViewModel)

protocol IPlaygroundViewModel: QuickInteractible {
    var rightSidePanelModel: RightSidePanelViewModelType { get }
}

final class PlaygroundViewModel: IPlaygroundViewModel {
    // MARK: - Members

    let rightSidePanelModel: RightSidePanelViewModelType

    // MARK: - Interface

    // MARK: - Input

    func interact(with view: QuickView) {
        rightSidePanelModel.interact(with: view)
    }

    // MARK: - Init

    init(rightSidePanelModel: RightSidePanelViewModelType) {
        self.rightSidePanelModel = rightSidePanelModel
    }

    convenience init() {
        self.init(
            rightSidePanelModel: RightSidePanelViewModel()
        )
    }
}
