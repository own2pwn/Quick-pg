//
//  UIView+Animations.swift
//  Quick-pg
//
//  Created by Evgeniy on 01/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import EPUIKit
import UIKit

public extension UIView {
    /// Animate changes to one or more views using `animationDuration` duration.
    static func animate(animations: @escaping () -> Void) {
        UIView.animate(withDuration: animationDuration, animations: animations)
    }

    /// Default duration when using extension methods.
    static var animationDuration: TimeInterval = 0.25
}

public extension UIView {
    static func serial(animations: @escaping () -> Void, on view: UIView) {
        AnimationQueue.run(animations, on: view)
    }

    static func serial(animation: Animations) {
        return serial(animations: animation.animationBlock, on: animation.subject)
    }
}
