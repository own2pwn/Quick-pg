//
//  LivePlaceholderTextField.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import UIKit

final class LivePlaceholderTextField: EPTextField, UITextFieldDelegate {
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

    private var currentText: String?

    private var selectionObserver: NSKeyValueObservation?

    private var currentTextRange: UITextRange?

    //

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
        observeSelection()
        setupPlaceholderLabel()
        delegate = self
    }

    private func observeEditing() {
        addTarget(
            self, action: #selector(handleTextChange),
            for: UIControl.Event.editingChanged
        )
    }

    private func observeSelection() {
        selectionObserver = observe(\.selectedTextRange, options: [.new]) { [weak self] _, change in
            if let change = change.newValue {
                self?.currentTextRange = change
            }
        }
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
    private func handleTextChange1() {
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

    // MARK: - Types

    enum ChangeType {
        case none
        case append(Int)
        case delete
        // replace aka paste?
    }

    private var lastChangeType: ChangeType = .none

    func textField(_: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = currentText //textField.text
        let currentText = Backed(textFieldText)
        updateLastAction(range: range, string: string)

        // range.len == to be removed

        if let stringRange: Range<String.Index> = Range<String.Index>(range, in: currentText) {
            let newString = currentText.replacingCharacters(in: stringRange, with: string)
            print("^ [\(currentText)] => [\(newString)] => \(caretPosition!)")

            return true
        }

        return false

        // write custom logic for paste, select, replace, delete...
    }

    @objc
    private func handleTextChange() {
        currentText = text
        currentTextRange = selectedTextRange
        print("text: \(text!); \(caretPosition(in: currentTextRange)!)")
    }

    private func updateLastAction(range: NSRange, string: String) {
        lastChangeType = range.length > 0 ? .delete : .append(string.length)
        _ = string
    }

    override func deleteBackward() {
        guard
            let caretPosition = caretPosition(in: currentTextRange)
        else { return }

        print("caret at: \(caretPosition)")
        let deleteRange: NSRange = NSRange(location: caretPosition - 1, length: 1)
        if textField(self, shouldChangeCharactersIn: deleteRange, replacementString: String.empty) {
            super.deleteBackward()
        }
    }
}
