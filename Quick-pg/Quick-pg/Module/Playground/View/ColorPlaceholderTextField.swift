//
//  ColorPlaceholderTextField.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import UIKit

final class ColorPlaceholderTextField: StaticPlaceholderTextField, UITextFieldDelegate {
    // MARK: - Output

    var onWantBecomeFirstResponder: (() -> Void)?

    var onWantResignFirstResponder: (() -> Void)?

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

        add(validator: EPTextField.Validator(closure: checkTextIsColor))
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
