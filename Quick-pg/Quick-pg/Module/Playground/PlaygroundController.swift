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

open class StaticPlaceholderTextField: EPTextField {
    // MARK: - Members

    public var placeholderLabelText: String?

    public var placeholderTextColor: UIColor?

    public var placeholderFont: UIFont?

    // MARK: - Views

    private let placeholderLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    // MARK: - Interface

    func update() {
        updatePlaceholder()
        updatePlaceholderLabel()
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }

    private func internalInit() {
        setupPlaceholderLabel()
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

    // MARK: - Placeholder

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
}

final class PlaygroundSidePanelView: UIView {
    // MARK: - Views

    private lazy var collectionView: CollectionView = {
        let collectionView = CollectionView()
        collectionView.provider = collectionProvider

        collectionView.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.9098039216, blue: 0.9647058824, alpha: 1)
        collectionView.layer.cornerRadius = 8

        return collectionView
    }()

    private let backgroundColorCell: ColorPlaceholderTextField = {
        let textField = ColorPlaceholderTextField()
        textField.font = UIFont.systemFont(ofSize: 16)

        textField.placeholderTextColor = #colorLiteral(red: 0.2078431373, green: 0.2470588235, blue: 0.3333333333, alpha: 1)
        textField.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.5137254902, blue: 0.5529411765, alpha: 1)

        textField.leftViewInsets.left = 8
        textField.contentInsets.setHorizontal(20)

        textField.update()

        return textField
    }()

    // MARK: - Members

    private var cells: [UIView] = []

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

        backgroundColorCell.onWantBecomeFirstResponder = {
            g_CustomKeyboardAllowed = false
        }

        backgroundColorCell.onWantResignFirstResponder = {
            g_CustomKeyboardAllowed = true
        }

        backgroundColorCell.onValidColorInput = { text in
            print("in: \(text)")
        }

        cells = [backgroundColorCell]
        collectionProvider.views = cells
    }

    // MARK: - Helpers

    func sizeProvider(at _: Int, data _: UIView, collectionSize: CGSize) -> CGSize {
        let height: CGFloat = 64

        return CGSize(width: collectionSize.width, height: height)
    }

    private lazy var collectionProvider: SimpleViewProvider = {
        let sizeSource: SizeSource<UIView> = ClosureSizeSource<UIView>(
            sizeSource: sizeProvider
        )
        let flowLayout = FlowLayout(spacing: 16)

        return SimpleViewProvider(
            views: cells,
            sizeSource: sizeSource,
            layout: flowLayout
        )
    }()

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
    @discardableResult
    func setCaret(at position: UITextPosition?) -> Bool {
        if let newCaretPosition = position {
            selectedTextRange = textRange(from: newCaretPosition, to: newCaretPosition)

            return true
        }
        return false
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

extension String: Fallbacked {
    static let defaultValue: String = ""
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

// ====

final class ColorPlaceholderTextField: StaticPlaceholderTextField, UITextFieldDelegate {
    // MARK: - Output

    var onWantBecomeFirstResponder: (() -> Void)?

    var onWantResignFirstResponder: (() -> Void)?

    var onValidColorInput: ((String) -> Void)?

    // MARK: - Overrides

    override var canBecomeFirstResponder: Bool {
        let desiredValue = super.canBecomeFirstResponder
        if desiredValue {
            onWantBecomeFirstResponder?()
        }

        return desiredValue
    }

    override var canResignFirstResponder: Bool {
        let desiredValue = super.canResignFirstResponder
        if desiredValue {
            onWantResignFirstResponder?()
        }

        return desiredValue
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
        returnKeyType = .done

        autocorrectionType = .no
        autocapitalizationType = .allCharacters

        placeholderLabelText = "#"
        placeholder = "FAFBFC"

        delegate = self

        addTarget(
            self,
            action: #selector(handleTypedText),
            for: UIControl.Event.editingDidEnd
        )
    }

    @objc
    private func handleTypedText() {
        let colorValue: String = text.unsafelyUnwrapped
        if checkTextIsColor(colorValue) {
            onValidColorInput?(colorValue)
        }
    }

    // MARK: - Editing

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText: String = Backed(textField.text)
        var newText: String = currentText

        if let replacementRange: Range<String.Index> = Range<String.Index>(range, in: currentText) {
            newText = currentText.replacingCharacters(in: replacementRange, with: string)
        }

        return checkTextValid(newText)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    // MARK: - Validators

    private func checkTextValid(_ newText: String) -> Bool {
        return newText.isHexOnly && newText.length <= Backed(placeholder?.length)
    }

    private func checkTextIsColor(_ text: String) -> Bool {
        guard checkTextValid(text) else {
            return false
        }
        return text.length == 6
    }
}

// ====

extension String {
    var isHexOnly: Bool {
        let disallowedChars: CharacterSet =
            CharacterSet(charactersIn: "A" ... "F").inverted

        return uppercased().rangeOfCharacter(from: disallowedChars) == nil
    }
}

extension String {
    //    func substring(with range: ClosedRange<Int>) -> String {
    //        let lower = index(startIndex, offsetBy: range.lowerBound)
    //        let upper = index(startIndex, offsetBy: range.upperBound)
    //        let stringRange = Range<String.Index>(uncheckedBounds: (lower, upper))
    //
    //        return substring(with: stringRange)
    //    }

    func substring(with range: ClosedRange<Int>) -> String {
        let lower = index(startIndex, offsetBy: range.lowerBound)
        let upper = index(startIndex, offsetBy: range.upperBound)

        return String(self[lower ... upper])
    }
}
