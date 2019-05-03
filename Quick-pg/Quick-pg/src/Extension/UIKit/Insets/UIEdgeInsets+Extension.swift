//
//  UIEdgeInsets+Extension.swift
//  Quick-pg
//
//  Created by Evgeniy on 30/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {
    mutating func setHorizontal(_ value: CGFloat) {
        left = value
        right = value
    }

    func horizontally(by value: CGFloat) -> UIEdgeInsets {
        var mutated = self
        mutated.left = value
        mutated.right = value

        return mutated
    }
}
