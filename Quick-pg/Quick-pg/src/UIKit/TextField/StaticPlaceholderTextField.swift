//
//  StaticPlaceholderTextField.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit

open class StaticPlaceholderTextField: EPTextField {
    // MARK: - Members

    public var placeholderLabelText: String?

    public var placeholderTextColor: UIColor?

    public var placeholderFont: UIFont?

    public var insetFromLeftView: CGFloat = 4

    // MARK: - Views

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

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

    // MARK: - Overrides

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var desiredBounds: CGRect = super.textRect(forBounds: bounds)
        desiredBounds.origin.x = insetFromLeftView + placeholderLabel.frame.maxX

        return desiredBounds
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var desiredBounds: CGRect = super.editingRect(forBounds: bounds)
        desiredBounds.origin.x = insetFromLeftView + placeholderLabel.frame.maxX

        return desiredBounds
    }

    // MARK: - Layout

    open override func layoutSubviews() {
        placeholderLabel.sizeToFit()

        super.layoutSubviews()
    }
}
