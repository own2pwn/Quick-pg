//
//  Animations.swift
//  Quick-pg
//
//  Created by Evgeniy on 01/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import EPUIKit
import UIKit

public enum Animations {
    case scaleDown(UIView)
    case resetScale(UIView)

    var animationBlock: VoidBlock {
        switch self {
        case let .scaleDown(view):
            return { view.transform = CGAffineTransform.identity.scaledBy(x: 0.92, y: 0.92) }

        case let .resetScale(view):
            return { view.transform = CGAffineTransform.identity }
        }
    }

    var subject: UIView {
        switch self {
        case let .scaleDown(view):
            return view

        case let .resetScale(view):
            return view
        }
    }
}
