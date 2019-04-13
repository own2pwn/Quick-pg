//
//  PlaygroundSidePanelView.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import CollectionKit
import UIKit

open class EPView: UIView {
    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {}
}

final class PlaygroundSidePanelView: EPView {
    // MARK: - Views

    private lazy var collectionView: CollectionView = {
        let collectionView = CollectionView()
        collectionView.provider = collectionProvider

        collectionView.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.9098039216, blue: 0.9647058824, alpha: 1)
        collectionView.layer.cornerRadius = 8

        return collectionView
    }()

    private let backgroundColorCell: ColorPlaceholderTextField = {
        let textField = ColorPlaceholderTextField()
        textField.font = UIFont.systemFont(ofSize: 16)

        textField.placeholderTextColor = #colorLiteral(red: 0.2078431373, green: 0.2470588235, blue: 0.3333333333, alpha: 1)
        textField.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.5137254902, blue: 0.5529411765, alpha: 1)

        textField.leftViewInsets.left = 8
        textField.contentInsets.setHorizontal(20)

        textField.update()

        return textField
    }()

    // MARK: - Members

    private let viewModel: IRightSidePanelViewModel

    private var cells: [UIView] = []

    // MARK: - Init

    init(viewModel: IRightSidePanelViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    override func setup() {
        [collectionView]
            .forEach(addSubview)

        backgroundColorCell.onWantBecomeFirstResponder = {
            g_CustomKeyboardAllowed = false
            // todo: viewModel view: UIView wants become first responder
            // then check if view is textfield and change global var
        }

        backgroundColorCell.onWantResignFirstResponder = {
            g_CustomKeyboardAllowed = true
        }

        cells = [backgroundColorCell]
        collectionProvider.views = cells

        setupControls()
    }

    private func setupControls() {
        backgroundColorCell.onValidValueEntered = { [unowned self] colorText in
            self.viewModel.handle(interaction: .setBackground(hex: colorText))

            // cell.apply(value: String)
            // backgroundCellWantsApply(value: String)
            // -> apply(background: String)
        }
    }

    // MARK: - Helpers

    func sizeProvider(at _: Int, data _: UIView, collectionSize: CGSize) -> CGSize {
        let height: CGFloat = 64

        return CGSize(width: collectionSize.width, height: height)
    }

    private lazy var collectionProvider: SimpleViewProvider = {
        let sizeSource: SizeSource<UIView> = ClosureSizeSource<UIView>(
            sizeSource: sizeProvider
        )
        let flowLayout = FlowLayout(spacing: 16)

        return SimpleViewProvider(
            views: cells,
            sizeSource: sizeSource,
            layout: flowLayout
        )
    }()

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.pin
            .all()
            .margin(8)
    }
}

// uicolor + hex

// str -> color and vice versa

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
