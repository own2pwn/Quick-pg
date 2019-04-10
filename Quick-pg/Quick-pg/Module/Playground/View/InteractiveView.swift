//
//  InteractiveView.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit

protocol InteractiveViewOut: class {
    var tapSignal: Signal { get }
}

open class InteractiveView: UIView, InteractiveViewOut {
    // MARK: - Output

    lazy var tapSignal = Signal()

    // MARK: - Members

    public let viewType: InteractiveViewType

    // MARK: - Init

    public convenience init() {
        self.init(viewType: .plain)
    }

    public init(viewType: InteractiveViewType) {
        self.viewType = viewType
        super.init(frame: .zero)

        internalInit()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func internalInit() {
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(handleTap)
            )
        )
    }

    // MARK: - Actions

    @objc
    private func handleTap() {
        tapSignal.tell()
    }
}
