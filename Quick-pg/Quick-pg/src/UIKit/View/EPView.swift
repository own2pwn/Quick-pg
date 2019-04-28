//
//  EPView.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit

protocol ILayoutable: class {
    func layout()
}

open class EPView: UIView, ILayoutable {
    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {}

    // MARK: - Layout

    open override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    func layout() {}
}
