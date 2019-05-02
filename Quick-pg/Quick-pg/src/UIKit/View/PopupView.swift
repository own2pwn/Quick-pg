//
//  PopupView.swift
//  Quick-pg
//
//  Created by Evgeniy on 30/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import EPUIKit
import UIKit

final class PopupView: EPShadowCardView {
    // MARK: - Views

    private let doneButton: EPTitledButton = {
        let btn = EPTitledButton()
        let font: UIFont? = Fonts.MontserratSemibold(ofSize: 16)

        btn.setTitleFont(font)
        btn.setTitleColor(#colorLiteral(red: 0.1499999464, green: 0.1499999464, blue: 0.1499999464, alpha: 1), for: .normal)
        btn.setTitle("Done", for: .normal)

        btn.cornerRadius = nil
        btn.backgroundColor = #colorLiteral(red: 0.9309999943, green: 0.9462000728, blue: 0.9499999881, alpha: 1)

        btn.contentEdgeInsets.left = 16
        btn.contentEdgeInsets.right = 16

        btn.shadow = Shadow(
            color: #colorLiteral(red: 0.9400001168, green: 0.8694999814, blue: 0.7049998641, alpha: 1), radius: 8,
            offset: CGSize(width: 0, height: 0.25),
            opacity: 0.2
        )

        return btn
    }()

    private let textField: StaticPlaceholderTextField = {
        let textField = StaticPlaceholderTextField()
        textField.font = Fonts.CoreSansARMedium(ofSize: 18)

        textField.textColor = #colorLiteral(red: 0.9309999943, green: 0.9462000728, blue: 0.9499999881, alpha: 1)
        textField.placeholderTextColor = #colorLiteral(red: 0.7409999967, green: 0.7643999457, blue: 0.7799999118, alpha: 1)
        textField.backgroundColor = .clear // #colorLiteral(red: 0.436576277, green: 0.8080026507, blue: 0.5136813521, alpha: 1)

        textField.placeholder = "View internal name"
        textField.update()

        return textField
    }()

    override var views: [UIView] {
        return [doneButton, textField]
    }

    // MARK: - Setup

    override func setup() {
        contentView.backgroundColor = #colorLiteral(red: 0.1499999464, green: 0.1499999464, blue: 0.1499999464, alpha: 1)
        cornerRadius = 6

        shadow = Shadow(
            color: #colorLiteral(red: 0.1699999571, green: 0.1699999571, blue: 0.1699999571, alpha: 1), radius: 8,
            offset: CGSize(width: 0, height: 0.75),
            opacity: 0.5
        )
    }

    // MARK: - Layout

    override func layout() {
        doneButton.pin
            .top()
            .end()
            .margin(8)
            .height(32)
            .sizeToFit(.height)

        textField.pin
            .height(32)
            .below(of: doneButton)
            .marginTop(32)
            .horizontally(10)

        pin.height(textField.frame.maxY + 24)
            .aspectRatio(1 + (1 / 1.2))
    }
}
