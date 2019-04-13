//
//  Array+Validators.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

extension Array where Element == Bool {
    func allValid() -> Bool {
        guard !isEmpty else {
            return false
        }

        let setValue = Set<Bool>(self)

        return !setValue.contains(false)
    }

    func allInvalid() -> Bool {
        guard !isEmpty else {
            return false
        }

        let setValue = Set<Bool>(self)

        return !setValue.contains(true)
    }

    func hasInvalid() -> Bool {
        guard !isEmpty else {
            return false
        }

        return !allValid()
    }

    func hasValid() -> Bool {
        guard !isEmpty else {
            return false
        }

        return !allInvalid()
    }
}
