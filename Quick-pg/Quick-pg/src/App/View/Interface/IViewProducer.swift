//
//  IViewProducer.swift
//  Quick-pg
//
//  Created by Evgeniy on 02/05/2019.
//  Copyright © 2019 surge. All rights reserved.
//

import Foundation

protocol IViewProducer: class {
    var onProduced: SignalM<InteractiveView, ViewProducer> { get }

    var onInteractionEnded: SignalM<InteractiveView, ViewProducer> { get }
}
