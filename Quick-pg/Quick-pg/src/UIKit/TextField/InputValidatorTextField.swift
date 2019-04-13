//
//  InputValidatorTextField.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import UIKit

open class InputValidatorTextField: EPTextField, UITextFieldDelegate {
    // MARK: - Members

    public typealias InputValidatorType = ((String) -> Bool)

    public typealias InputValidator = ClosureBox<InputValidatorType>

    // MARK: - Validators

    open var inputValidators = Set<InputValidator>()

    open func add(inputValidator: InputValidator) {
        inputValidators.insert(inputValidator)
    }

    open func remove(inputValidator: InputValidator) {
        inputValidators.remove(inputValidator)
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
        delegate = self
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText: String = Backed(textField.text)
        var newText: String = currentText

        if let replacementRange: Range<String.Index> = Range<String.Index>(range, in: currentText) {
            newText = currentText.replacingCharacters(in: replacementRange, with: string)
        }

        let shouldChange: Bool
        shouldChange = inputValidators
            .map { $0.closure }
            .map { $0(newText) }
            .allValid()

        return shouldChange
    }
}
