//
//  UIControl+Extensions.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 14/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import Combine

extension UIControl {

    func publisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
        Publishers.UIControlPublisher(control: self, events: events).eraseToAnyPublisher()
    }
}
