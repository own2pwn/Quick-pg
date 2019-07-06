//
//  UITextField+Caret.swift
//  Quick-pg
//
//  Created by Evgeniy on 30/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import UIKit

public extension UITextField {
    @discardableResult
    func setCaret(at position: UITextPosition?) -> Bool {
        if let newCaretPosition = position {
            selectedTextRange = textRange(from: newCaretPosition, to: newCaretPosition)

            return true
        }
        return false
    }

    @discardableResult
    func setCaret(at offset: Int) -> Bool {
        if let newCaretPosition = position(from: beginningOfDocument, offset: offset) {
            selectedTextRange = textRange(from: newCaretPosition, to: newCaretPosition)

            return true
        }
        return false
    }
}

public extension UITextField {
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
