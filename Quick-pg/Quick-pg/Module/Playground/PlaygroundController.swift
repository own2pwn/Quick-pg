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

    public var leftViewInsets: UIEdgeInsets = .zero

    // MARK: - Insets

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }

//    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: contentInsets)
//    }

    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: leftViewInsets)
    }
}

final class LivePlaceholderTextField: EPTextField {
    // MARK: - Members

    public var placeholderLabelText: String?

    public var placeholderTextColor: UIColor?

    public var placeholderFont: UIFont?

    // MARK: - Views

    private let placeholderLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    // MARK: - Logic

    private var previousTextString: NSAttributedString?

    private var previousPlaceholderString: NSAttributedString?

    private var previousFullLength: Int {
        let textLen: Int = Fallback(to: 0, previousTextString?.length)
        let placeholderLen: Int = Fallback(to: 0, previousPlaceholderString?.length)

        return textLen + placeholderLen
    }

    // MARK: - Interface

    func update() {
        updatePlaceholder()
        updatePlaceholderLabel()
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
        observeEditing()
        setupPlaceholderLabel()
    }

    private func observeEditing() {
        addTarget(
            self, action: #selector(handleTextChange),
            for: UIControl.Event.editingChanged
        )
    }

    private func setupPlaceholderLabel() {
        leftView = placeholderLabel
        leftViewMode = .always
    }

    // MARK: - Helpers

    private func updatePlaceholder() {
        guard
            let text = placeholder
        else { return }

        attributedPlaceholder = getCustomPlaceholder(for: text)
    }

    private func updatePlaceholderLabel() {
        placeholderLabel.text = placeholderLabelText
        placeholderLabel.font = placeholderFont ?? font
        placeholderLabel.textColor = placeholderTextColor ?? textColor

        placeholderLabel.sizeToFit()
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
        previousTextString = textString

        let placeholderRange: NSRange = NSRange(
            location: text.length,
            length: placeholder.length - text.length
        )

        let placeholderString: NSAttributedString =
            getCustomPlaceholder(for: placeholder)
            .attributedSubstring(from: placeholderRange)

        previousPlaceholderString = placeholderString

        let resultString = NSMutableAttributedString(attributedString: textString)
        resultString.append(placeholderString)

        print("^ tl: \(text.length)")

        return resultString
    }

    @objc
    private func handleTextChange() {
        guard
            let text = text,
            let placeholder = placeholder,
            Backed(previousTextString?.length) < placeholder.length
        else { return }

        let l = previousFullLength
        attributedText = getTextWithPlaceholder(for: text, placeholder: placeholder)

        let newTextLength: Int = Backed(previousTextString?.length)
        let newCaretPosition: UITextPosition? = position(from: beginningOfDocument, offset: newTextLength)
        setCaret(at: newCaretPosition)
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
        textField.autocapitalizationType = .allCharacters

        textField.placeholderLabelText = "#"
        textField.placeholder = "FAFBFC"

        textField.placeholderTextColor = #colorLiteral(red: 0.2078431373, green: 0.2470588235, blue: 0.3333333333, alpha: 1)
        textField.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.5137254902, blue: 0.5529411765, alpha: 1)

        textField.leftViewInsets.left = 8
        textField.contentInsets.setHorizontal(20)

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

extension String {
    @inlinable
    var length: Int {
        return count
    }
}

extension UITextField {
    func setCaret(at position: UITextPosition?) {
        if let newCaretPosition = position {
            selectedTextRange = textRange(from: newCaretPosition, to: newCaretPosition)
        }
    }
}

extension Optional {
    func or<T>(_ fallback: T) -> T {
        if let boxed = self as? T {
            return boxed
        }
        return fallback
    }
}

protocol Fallbacked {
    associatedtype T

    static var defaultValue: T { get }
}

func Fallback<T>(to value: T, _ optional: T?) -> T {
    if let boxed = optional {
        return boxed
    }
    return value
}

func Backed<T: Fallbacked>(_ optional: T?) -> T {
    if let boxed = optional {
        return boxed
    }
    return unsafeBitCast(T.defaultValue, to: T.self)
}

extension Int: Fallbacked {
    static let defaultValue: Int = 0
}
