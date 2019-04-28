//
//  RightSidePanelView.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import CollectionKit
import UIKit

final class RightSidePanelView: EPView {
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

        textField.leftViewInsetFromLeft = 8
        textField.contentInsets.right = 20

        textField.update()

        // todo: make a cell
        // cell: UIView -> hInset = 20; etc

        return textField
    }()

    private let cornerRadiusCell: SidePanelTextField = {
        let textField = SidePanelTextField()
        textField.font = UIFont.systemFont(ofSize: 16)

        textField.placeholderTextColor = #colorLiteral(red: 0.2078431373, green: 0.2470588235, blue: 0.3333333333, alpha: 1)
        textField.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.5137254902, blue: 0.5529411765, alpha: 1)

        textField.leftViewInsetFromLeft = 8
        textField.contentInsets.right = 20

        textField.placeholderLabelText = "Corner:"
        textField.placeholder = "8"

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

        makeCells()
        setupControls()
    }

    private func makeCells() {
        cells = [
            backgroundColorCell,
            cornerRadiusCell,
        ]
        collectionProvider.views = cells
    }

    private func setupControls() {
        backgroundColorCell.onValidValueEntered = { [unowned self] colorText in
            self.viewModel.handle(interaction: .setBackground(hex: colorText))

            // cell.apply(value: String)
            // backgroundCellWantsApply(value: String)
            // -> apply(background: String)
        }

        let numericTextValidator: (String) -> Bool = { text in
            let disallowedCharset: CharacterSet = CharacterSet.decimalDigits.inverted

            return text.rangeOfCharacter(from: disallowedCharset) == nil
        }
        cornerRadiusCell.add(inputValidator: ClosureBox<SidePanelTextField.InputValidatorType>(closure: numericTextValidator))

        let numericValueValidator: (String) -> Bool = { text in
            guard let intValue = Int(text) else {
                return false
            }

            return intValue >= 0 && intValue <= 100
        }
        cornerRadiusCell.add(validator: EPTextField.Validator(closure: numericValueValidator))

        cornerRadiusCell.onValidValueEntered = { [unowned self] cornerRadius in
            self.viewModel.handle(interaction: .setCorner(radius: cornerRadius))
        }
    }

    // MARK: - Helpers

    func sizeProvider(at _: Int, data _: UIView, collectionSize: CGSize) -> CGSize {
        let perRow: CGFloat = 2
        let spacing: CGFloat = 4
        let width: CGFloat = collectionSize.width

        let side: CGFloat = (width / perRow) - (spacing * (perRow - 1))

        return CGSize(width: side, height: side)
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

        backgroundColorCell.update()
        cornerRadiusCell.update()
    }
}

protocol ISidePanelCell: class {
    func setText(_ text: String)
}

final class SidePanelCell: EPView, ISidePanelCell {
    // MARK: - Views

    private let iconView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = #colorLiteral(red: 0.1569964886, green: 0.1586591899, blue: 0.2031466067, alpha: 1)

        return label
    }()

    // MARK: - Interface

    func setText(_ text: String) {
        titleLabel.text = text
        layoutLabel()
    }

    // MARK: - Setup

    override func setup() {
        backgroundColor = #colorLiteral(red: 0.9309999943, green: 0.9462000728, blue: 0.9499999881, alpha: 1)

        [iconView, titleLabel]
            .forEach(addSubview)
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        iconView.pin
            .size(32)
            .center()

        layoutLabel()
    }

    private func layoutLabel() {
        titleLabel.pin
            .below(of: iconView)
            .marginTop(8)
            .horizontally(4)
            .sizeToFit(.width)
    }
}
