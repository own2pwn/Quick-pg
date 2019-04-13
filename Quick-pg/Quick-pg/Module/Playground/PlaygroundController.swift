//
//  ViewController.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import CollectionKit
import PinLayout
import UIKit

public enum QuickViewType {
    case plain
}

final class PlaygroundViewHolder {}

final class PlaygroundController: UIViewController {
    // MARK: - Views

    private let clickyView: InteractiveView = {
        let view = SelectableView()
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.3568627451, blue: 0.4392156863, alpha: 1)
        view.layer.cornerRadius = 8

        return view
    }()

    private lazy var sidePanelView: PlaygroundSidePanelView = {
        let view = PlaygroundSidePanelView(
            viewModel: viewModel.rightSidePanelModel
        )
        view.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2352941176, blue: 0.3137254902, alpha: 1)
        view.layer.cornerRadius = 8

        return view
    }()

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

    private func setup() {
        [clickyView, sidePanelView]
            .forEach(view.addSubview)

        clickyView.tapSignal.listen { (quick: QuickView) in
            self.viewModel.interact(with: quick)
        }
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

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
