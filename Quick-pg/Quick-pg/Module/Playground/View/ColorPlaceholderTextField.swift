//
//  ColorPlaceholderTextField.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import UIKit

final class ColorPlaceholderTextField: StaticPlaceholderValidatorTextField {
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

        add(inputValidator: ClosureBox<InputValidatorType>(closure: checkTextValid))
        add(validator: EPTextField.Validator(closure: checkTextIsColor))
    }

    // MARK: - Editing

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
