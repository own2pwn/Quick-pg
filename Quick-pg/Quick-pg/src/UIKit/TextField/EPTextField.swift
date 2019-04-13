//
//  EPTextField.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit

// TODO: red color if wrong, etc
open class EPTextField: UITextField {
    // MARK: - Types

    public typealias ValidatorType = ((String) -> Bool)

    public typealias Validator = ClosureBox<ValidatorType>

    // MARK: - Output

    open var onValidValueEntered: ((String) -> Void)?

    // MARK: - Members

    public var contentInsets: UIEdgeInsets = .zero

    public var leftViewInsets: UIEdgeInsets = .zero

    // MARK: - Validators

    open var validators = Set<Validator>()

    open func add(validator: Validator) {
        validators.insert(validator)
    }

    open func remove(validator: Validator) {
        validators.remove(validator)
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
        addTarget(
            self,
            action: #selector(handleTypedText),
            for: UIControl.Event.editingDidEnd
        )
    }

    @objc
    private func handleTypedText() {
        if let textValue: String = text {
            let allValid: Bool

            allValid = validators
                .map { $0.closure }
                .map { $0(textValue) }
                .allValid()

            if allValid {
                onValidValueEntered?(textValue)
            }
        }
    }

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

    // MARK: - Helpers
}
