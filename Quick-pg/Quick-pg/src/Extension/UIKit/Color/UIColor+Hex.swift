//
//  UIColor+Hex.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit

extension String {
    var hexTrimmed: String {
        let disallowedChars: CharacterSet =
            CharacterSet(charactersIn: "A" ... "F")
            .union(CharacterSet(charactersIn: "0" ... "9"))
            .inverted

        return trimmingCharacters(in: disallowedChars)
    }
}

extension UIColor {
    var hexValue: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0

        return String(format: "#%06x", rgb)
    }
}

extension UIColor {
    static func fromHex(_ str: String, fallback: UIColor = UIColor.white) -> UIColor {
        let scanner = Scanner(string: str.hexTrimmed)
        var hexValue: UInt64 = 0

        if scanner.scanHexInt64(&hexValue) {
            return UIColor(hexValue: Int(hexValue))
        } else {
            return fallback
        }
    }

    static func fromHex(_ str: String, alpha: CGFloat, fallback: UIColor = UIColor.white) -> UIColor {
        return fromHex(str, fallback: fallback).withAlphaComponent(alpha)
    }

    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        self.init(
            red: UIColor.intToFloat(red),
            green: UIColor.intToFloat(green),
            blue: UIColor.intToFloat(blue),
            alpha: alpha
        )
    }

    convenience init(hexValue: Int) {
        self.init(
            red: (hexValue >> 16) & 0xFF,
            green: (hexValue >> 8) & 0xFF,
            blue: hexValue & 0xFF
        )
    }

    convenience init?(hexStr: String) {
        let cleanedStr: String = hexStr.hexTrimmed
        guard cleanedStr.isHexOnly, cleanedStr.length == 6 else {
            return nil
        }

        let scanner = Scanner(string: cleanedStr)
        var hexValue: UInt64 = 0

        guard scanner.scanHexInt64(&hexValue) else {
            return nil
        }

        self.init(hexValue: Int(hexValue))
    }

    // MARK: - Helpers

    private static func intToFloat(_ arg: Int) -> CGFloat {
        return CGFloat(arg) / 255
    }
}
