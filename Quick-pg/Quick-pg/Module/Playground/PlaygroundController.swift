//
//  ViewController.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import CollectionKit
import EPUIKit
import PinLayout
import UIKit

public enum QuickViewType {
    case plain
}

final class PlaygroundViewHolder {}

final class InteractivePopup: EPCardView {
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

    override var views: [UIView] {
        return [doneButton]
    }

    // MARK: - Setup

    override func setup() {
        backgroundColor = #colorLiteral(red: 0.1499999464, green: 0.1499999464, blue: 0.1499999464, alpha: 1)
        cornerRadius = 6
    }

    // MARK: - Layout

    override func layout() {
        pin.height(280).width(540)

        doneButton.pin
            .top()
            .end()
            .margin(8)
            .height(32)
            .sizeToFit(.height)
    }
}

final class PlaygroundController: EYController {
    // MARK: - Views

    private let clickyView: InteractiveView = {
        let view = SelectableView()
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.3568627451, blue: 0.4392156863, alpha: 1)
        view.layer.cornerRadius = 8

        return view
    }()

    private lazy var sidePanelView: RightSidePanelView = {
        let view = RightSidePanelView(
            viewModel: viewModel.rightSidePanelModel
        )
        view.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2352941176, blue: 0.3137254902, alpha: 1)
        view.layer.cornerRadius = 8

        return view
    }()

    private let popupView: InteractivePopup = {
        let view = InteractivePopup()

        return view
    }()

    override var views: [UIView] {
        return [clickyView, sidePanelView, popupView]
    }

    // MARK: - Members

    private let viewModel: IPlaygroundViewModel = {
        let model = PlaygroundViewModel()

        return model
    }()

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        view.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.9137254902, blue: 0.8078431373, alpha: 1)
    }

    override func setup() {
        clickyView.tapSignal.listen { (quick: QuickView) in
            self.viewModel.interact(with: quick)
        }
    }

    // MARK: - Layout

    override func layout() {
        clickyView.pin
            .height(216)
            .width(272)
            .center()
            .marginHorizontal(-64)

        sidePanelView.pin
            .vertically(64)
            .width(248)
            .end(view.pin.safeArea)
            .marginEnd(24)

        popupView
            .layoutIfNeeded()

        popupView.pin
            .center()
    }
}

extension Bool {
    @inlinable
    var reversed: Bool {
        return !self
    }
}

extension UIEdgeInsets {
    mutating func setHorizontal(_ value: CGFloat) {
        left = value
        right = value
    }
}

extension String {
    @inlinable
    var length: Int {
        return count
    }
}

extension UITextField {
    @discardableResult
    func setCaret(at position: UITextPosition?) -> Bool {
        if let newCaretPosition = position {
            selectedTextRange = textRange(from: newCaretPosition, to: newCaretPosition)

            return true
        }
        return false
    }
}

extension UITextField {
    var caretPosition: Int? {
        guard
            let selectedRange = selectedTextRange
        else { return nil }

        return offset(
            from: beginningOfDocument,
            to: selectedRange.start
        )
    }

    func caretPosition(in selectedRange: UITextRange?) -> Int? {
        guard
            let selectedRange = selectedRange
        else { return nil }

        return offset(
            from: beginningOfDocument,
            to: selectedRange.start
        )
    }
}

extension String {
    static let empty: String = ""
}
