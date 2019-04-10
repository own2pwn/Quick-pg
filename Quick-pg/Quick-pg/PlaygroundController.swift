//
//  ViewController.swift
//  Quick-pg
//
//  Created by Evgeniy on 10/04/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import PinLayout
import UIKit

typealias ActionBlock = () -> Void

protocol SignalProducer: class {
    func tell()
}

protocol SignalConsumer: class {
    func listen(action: @escaping ActionBlock)
}

final class Signal: SignalProducer, SignalConsumer {
    // MARK: - Members

    private var actions: [ActionBlock]

    // MARK: - Interface

    func listen(action: @escaping ActionBlock) {
        actions.append(action)
    }

    func tell() {
        actions.forEach(Signal.exec)
    }

    // MARK: - Helpers

    private static func exec(action: ActionBlock) {
        action()
    }

    // MARK: - Init

    init() {
        actions = []
    }
}

final class Relay<T> {
    // MARK: - Interface
}

typealias TapHandler = () -> Void

public enum InteractiveViewType {
    case plain
}

protocol InteractiveViewOut: class {
    var tapSignal: Signal { get }
}

protocol ISelectableView: class {
    var isSelected: Bool { get }

    func set(selected: Bool)
}

open class SelectableView: InteractiveView, ISelectableView {
    // MARK: - Members

    public var isSelected: Bool = false

    // MARK: - Interface

    func set(selected: Bool) {
        isSelected = selected
        // TODO: update selection state

        // shadow, etc
    }

    // MARK: - Init

    override func internalInit() {
        super.internalInit()

        tapSignal.listen(action: onTap)
    }

    // MARK: - Helpers

    private func onTap() {
        set(selected: isSelected.reversed)
    }
}

open class InteractiveView: UIView, InteractiveViewOut {
    // MARK: - Output

    lazy var tapSignal = Signal()

    // MARK: - Members

    public let viewType: InteractiveViewType

    // MARK: - Init

    public convenience init() {
        self.init(viewType: .plain)
    }

    public init(viewType: InteractiveViewType) {
        self.viewType = viewType
        super.init(frame: .zero)

        internalInit()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func internalInit() {
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(handleTap)
            )
        )
    }

    // MARK: - Actions

    @objc
    private func handleTap() {
        tapSignal.tell()
    }
}

final class PlaygroundController: UIViewController {
    // MARK: - Views

    private let clickyView: InteractiveView = {
        let view = SelectableView()
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.3568627451, blue: 0.4392156863, alpha: 1)
        view.layer.cornerRadius = 8

        return view
    }()

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        view.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.9137254902, blue: 0.8078431373, alpha: 1)
    }

    private func setup() {
        [clickyView].forEach(view.addSubview)
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        clickyView.pin
            .height(216)
            .width(272)
            .center()
    }
}

extension Bool {
    @inlinable
    var reversed: Bool {
        return !self
    }
}
