//
//  PlaygroundDockView.swift
//  Quick-pg
//
//  Created by Evgeniy on 02/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import CollectionKit
import EPUIKit
import UIKit

final class PlaygroundDockView: EPShadowCardView {
    // MARK: - Static

    private static let spacing: CGFloat = 20

    // MARK: - Types

    private typealias Model = String

    private typealias Cell = ViewProducer

    // MARK: - Views

    private lazy var collectionView: CollectionView = {
        let collectionView = CollectionView()
        collectionView.provider = collectionProvider
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    override var views: [UIView] {
        return [collectionView]
    }

    // MARK: - Cells

    private lazy var interactiveView: ViewProducer = {
        let view = ViewProducer(in: self)
        view.backgroundColor = #colorLiteral(red: 0.436576277, green: 0.8080026507, blue: 0.5136813521, alpha: 1)
        view.layer.cornerRadius = 12

        return view
    }()

    // MARK: - Members

    private let container: UIView

    private var models: [Model] = [
        "Dummy", "Dummy", "Dummy",
        "Dummy", "Dummy", "Dummy",
        "Dummy", "Dummy", "Dummy",
    ]

    // MARK: - Init

    init(in container: UIView) {
        self.container = container
        super.init(frame: .zero)
    }

    // MARK: - Setup

    override func setup() {
        makeCells()
    }

    private func makeCells() {
        collectionProvider.reloadData()
    }

    // MARK: - Collection Kit

    private func viewGenerator(model: Model, idx: Int) -> Cell {
        _ = (model, idx)

        let cell = ViewProducer(in: self)
        cell.backgroundColor = #colorLiteral(red: 0.436576277, green: 0.8080026507, blue: 0.5136813521, alpha: 1)
        cell.layer.cornerRadius = 12

        cell.onProduced
            .listen(handler: handle)

        cell.onInteractionEnded
            .listen(handler: handleEnd)

        return cell
    }

    private func viewUpdater(cell: Cell, model: Model, idx: Int) {
        _ = (model, idx)
        cell.layoutIfNeeded()
    }

    private func sizeSource(at _: Int, model _: Model, containerSize: CGSize) -> CGSize {
        return CGSize(width: 88, height: 84)
    }

    private lazy var collectionProvider: ComposedProvider = {
        let viewSource: ClosureViewSource<Model, Cell> = ClosureViewSource<Model, Cell>(
            viewGenerator: viewGenerator, viewUpdater: viewUpdater
        )

        let sectionProvider: BasicProvider<Model, Cell> = BasicProvider<Model, Cell>(
            dataSource: models, viewSource: viewSource, sizeSource: sizeSource
        )

        sectionProvider.layout = RowLayout(
            spacing: PlaygroundDockView.spacing,
            justifyContent: JustifyContent.center,
            alignItems: AlignItem.center
        )

        let mainLayout = FlowLayout()
            .inset(by: UIEdgeInsets.zero.horizontally(by: 32))

        let composedProvider = ComposedProvider(
            layout: mainLayout, sections: [sectionProvider]
        )

        return composedProvider
    }()

    // MARK: - Layout

    override func layout() {
        collectionView.pin.all()
    }

    private func layoutCell() {
        interactiveView.pin
            .height(84)
            .width(88)
            .center()
    }
}

// MARK: - Private

private extension PlaygroundDockView {
    // MARK: - Interactions

    private func handle(produced view: InteractiveView, sender: ViewProducer) {
        collectionView.isScrollEnabled = false

        /// converts cell (which is `sender` aka `ViewProducer`)
        /// center into `container` coordinate space
        /// because `view`'s new superView will be `container`
        view.center = convert(sender.center, to: container)

        container.addSubview(view)
    }

    private func handleEnd(with view: InteractiveView, sender _: ViewProducer) {
        collectionView.isScrollEnabled = true

        let mappedRect: CGRect = convert(contentView.frame, to: container)
        let insideDock: Bool = mappedRect.intersects(view.frame)

        if insideDock {
            return kill(view: view)
        }

        UIView.animate {
            view.setShadow(Shadow.clear)
        }
    }

    // MARK: - Helpers

    private func kill(view: UIView) {
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.calculationModeCubic, .allowUserInteraction], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.6, animations: {
                view.alpha = 0
            })

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
                view.transform = CGAffineTransform.identity.scaledBy(x: 0.3, y: 0.3)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.9, animations: {
                view.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
            })

        }) { _ in
            view.removeFromSuperview()
        }
    }
}
