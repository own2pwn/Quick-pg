//
//  String+Validators.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

extension String {
    var isHexOnly: Bool {
        let disallowedChars: CharacterSet =
            CharacterSet(charactersIn: "A" ... "F")
            .union(CharacterSet(charactersIn: "0" ... "9"))
            .inverted

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
