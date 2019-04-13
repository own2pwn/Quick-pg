//
//  PlaygroundSidePanelView.swift
//  Quick-pg
//
//  Created by Evgeniy on 13/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import CollectionKit
import UIKit

final class PlaygroundSidePanelView: UIView {
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

    private var cells: [UIView] = []

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
        [collectionView]
            .forEach(addSubview)

        backgroundColorCell.onWantBecomeFirstResponder = {
            g_CustomKeyboardAllowed = false
        }

        backgroundColorCell.onWantResignFirstResponder = {
            g_CustomKeyboardAllowed = true
        }

        backgroundColorCell.onValidValueEntered = { text in
            print("in: \(text)")
        }

        cells = [backgroundColorCell]
        collectionProvider.views = cells
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
