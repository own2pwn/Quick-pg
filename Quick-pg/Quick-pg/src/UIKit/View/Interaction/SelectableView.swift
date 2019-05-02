//
//  SelectableView.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit

protocol ISelectableView: class {
    var isSelected: Bool { get }

    func set(selected: Bool)
}

open class SelectableView: __InteractiveView, ISelectableView {
    // MARK: - Members

    public var isSelected: Bool = false

    // MARK: - Interface

    func set(selected: Bool) {
        isSelected = selected
        // TODO: update selection state

        // shadow, etc
    }

    // MARK: - Init

    override func internalInit() {
        super.internalInit()

        tapSignal.listen(action: onTap)
    }

    // MARK: - Helpers

    private func onTap() {
        set(selected: isSelected.reversed)
    }
}
