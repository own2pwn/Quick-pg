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
    // MARK: - Types

    private typealias Model = String

    private typealias Cell = SidePanelCell

    // MARK: - Views

    private lazy var collectionView: CollectionView = {
        let collectionView = CollectionView()
        collectionView.provider = collectionProvider

        collectionView.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.9098039216, blue: 0.9647058824, alpha: 1)
        collectionView.layer.cornerRadius = 8

        return collectionView
    }()

    private let viewNameCell: SidePanelCell = {
        let view = SidePanelCell()

        return view
    }()

    private let viewBackgroundColorCell: SidePanelCell = {
        let view = SidePanelCell()

        return view
    }()

    // MARK: - Members

    private let viewModel: IRightSidePanelViewModel

    private var cells: [Cell] = []

    private var models: [Model] = [
        "Name", "Background",
    ]

    // MARK: - Init

    init(viewModel: IRightSidePanelViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    override func setup() {
        [collectionView]
            .forEach(addSubview)

        makeCells()
    }

    private func makeCells() {
        cells = [
            viewNameCell,
            viewBackgroundColorCell,
        ]
        collectionProvider.reloadData()
    }

    // MARK: - Helpers

    private func viewSource(cell: Cell, model: Model, idx _: Int) {
        cell.update(with: model)
        cell.layoutIfNeeded()
    }

    private func sizeSource(at _: Int, model _: Model, containerSize: CGSize) -> CGSize {
        let perRow: CGFloat = 2
        let spacing: CGFloat = 4
        let width: CGFloat = containerSize.width

        // let side: CGFloat = (width - (spacing * (perRow - 1))) / perRow
        let side: CGFloat = ((spacing + width) / perRow) - spacing

        return CGSize(width: side, height: side)
    }

    private lazy var collectionProvider: BasicProvider<Model, Cell> = {
        let layout = FlowLayout()
        layout.interitemSpacing = 4
        layout.lineSpacing = 16

        // layout.justifyContent = .spa

        let provider: BasicProvider<Model, Cell> = BasicProvider<Model, Cell>(
            dataSource: models, viewSource: viewSource, sizeSource: sizeSource
        )
        provider.layout = layout//.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))

        return provider
    }()

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.pin
            .all()
            .margin(8)

        // viewNameCell.layoutIfNeeded()
    }
}

protocol ISidePanelCell: ILayoutable {
    func update(with text: String)

    var icon: UIImage? { get set }
}

final class SidePanelCell: EPView, ISidePanelCell {
    // MARK: - Members

    var icon: UIImage? {
        get { return iconView.image }
        set { iconView.image = icon }
    }

    // MARK: - Views

    private let iconView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = #colorLiteral(red: 0.9309999943, green: 0.9462000728, blue: 0.9499999881, alpha: 1)
        label.textAlignment = .center

        return label
    }()

    // MARK: - Interface

    func update(with text: String) {
        titleLabel.text = text
        layoutLabel()
    }

    // MARK: - Setup

    override func setup() {
        backgroundColor = #colorLiteral(red: 0.1569964886, green: 0.1586591899, blue: 0.2031466067, alpha: 1)
        layer.cornerRadius = 4
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        [iconView, titleLabel]
            .forEach(addSubview)
    }

    // MARK: - Layout

    override func layout() {
        iconView.pin
            .size(32)
            .center()

        layoutLabel()
    }

    private func layoutLabel() {
        titleLabel.pin
            .bottom(8)
            .horizontally(4)
            .sizeToFit(.width)
    }
}
