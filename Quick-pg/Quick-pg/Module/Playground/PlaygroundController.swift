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

final class Relay<T> {
    // MARK: - Interface
}

typealias TapHandler = () -> Void

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

    private let sidePanelView: PlaygroundSidePanelView = {
        let view = PlaygroundSidePanelView()
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

open class EPTextField: UITextField {
    // MARK: - Members

    public var contentInsets: UIEdgeInsets = .zero

    // MARK: - Insets

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }
}

final class LivePlaceholderTextField: EPTextField {
    // MARK: - Members

    public var placeholderTextColor: UIColor?

    public var placeholderFont: UIFont?

    public var placeholderLength: Int = 0

    // MARK: - Logic

    // MARK: - Interface

    func update() {
        updatePlaceholder()
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }

    private func internalInit() {
        addTarget(
            self, action: #selector(handleTextChange),
            for: UIControl.Event.editingChanged
        )
    }

    // MARK: - Helpers

    private func updatePlaceholder() {
        guard
            let text = placeholder
        else { return }

        attributedPlaceholder = getCustomPlaceholder(for: text)
    }

    private func getCustomPlaceholder(for text: String) -> NSAttributedString {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: placeholderTextColor ?? textColor,
            NSAttributedString.Key.font: placeholderFont ?? font,
        ]

        return NSAttributedString(
            string: text,
            attributes: placeholderAttributes
        )
    }

    private func getCustomText(for text: String) -> NSAttributedString {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: font,
        ]

        return NSAttributedString(
            string: text,
            attributes: placeholderAttributes
        )
    }

    private func getTextWithPlaceholder(for text: String, placeholder: String) -> NSAttributedString {
        let textString: NSAttributedString = getCustomText(for: text)

        let placeholderRange: NSRange = NSRange(
            location: text.count,
            length: placeholder.count - text.count
        )

        let placeholderString: NSAttributedString =
            getCustomPlaceholder(for: placeholder)
            .attributedSubstring(from: placeholderRange)

        let resultString = NSMutableAttributedString(attributedString: textString)
        resultString.append(placeholderString)

        return resultString
    }

    @objc
    private func handleTextChange() {
        guard
            let text = text,
            let placeholder = placeholder,
            text.count < placeholderLength
        else { return }

        attributedText = getTextWithPlaceholder(for: text, placeholder: placeholder)
    }
}

final class PlaygroundSidePanelView: UIView {
    // MARK: - Views

    private lazy var collectionView: CollectionView = {
        let view = CollectionView()
        view.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.9098039216, blue: 0.9647058824, alpha: 1)
        view.layer.cornerRadius = 8

        view.provider = makeCollectionViewProvider()

        return view
    }()

    private let dummyView: UIView = {
        let textField = LivePlaceholderTextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocorrectionType = .no

        textField.placeholder = "#FAFBFC"
        textField.placeholderLength = 6

        textField.placeholderTextColor = #colorLiteral(red: 0.2078431373, green: 0.2470588235, blue: 0.3333333333, alpha: 1)
        textField.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.5137254902, blue: 0.5529411765, alpha: 1)

        textField.contentInsets.setHorizontal(16)
        textField.update()

        return textField
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }

    private func internalInit() {
        [collectionView]
            .forEach(addSubview)
    }

    // MARK: - Helpers

    func sizeProvider(at _: Int, data _: UIView, collectionSize: CGSize) -> CGSize {
        let height: CGFloat = 64

        return CGSize(width: collectionSize.width, height: height)
    }

    private func makeCollectionViewProvider() -> Provider {
        let sizeSource: SizeSource<UIView> = ClosureSizeSource<UIView>(
            sizeSource: sizeProvider
        )

        let flowLayout = FlowLayout(spacing: 16)

        return SimpleViewProvider(
            views: [dummyView],
            sizeSource: sizeSource,
            layout: flowLayout
        )
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.pin
            .all()
            .margin(8)
    }
}

extension UIEdgeInsets {
    mutating func setHorizontal(_ value: CGFloat) {
        left = value
        right = value
    }
}
