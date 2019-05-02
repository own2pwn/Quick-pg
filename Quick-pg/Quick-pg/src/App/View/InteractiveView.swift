//
//  InteractiveView.swift
//  Quick-pg
//
//  Created by Evgeniy on 02/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import EPUIKit
import UIKit

final class InteractiveView: EPShadowView {
    // MARK: - Static

    static let shadow: Shadow = Shadow(
        color: #colorLiteral(red: 0.1499999464, green: 0.1499999464, blue: 0.1499999464, alpha: 1), radius: 8,
        offset: .zero, opacity: 0.3
    )

    // MARK: - Touches

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        superview?.bringSubviewToFront(self)
        UIView.animate {
            self.setShadow(InteractiveView.shadow)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        let moveDelta: CGPoint = self.moveDelta(from: touches)
        frame.origin.adjust(by: moveDelta)
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        UIView.animate {
            self.setShadow(Shadow.clear)
        }
    }

    override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        UIView.animate {
            self.setShadow(Shadow.clear)
        }
    }

    // MARK: - Helpers

    private func moveDelta(from touches: Set<UITouch>) -> CGPoint {
        guard let touch = touches.first else {
            return .zero
        }

        return moveDelta(touch: touch)
    }

    private func moveDelta(touch: UITouch) -> CGPoint {
        let current: CGPoint = touch.location(in: superview)
        let previous: CGPoint = touch.previousLocation(in: superview)

        return current - previous
    }
}
