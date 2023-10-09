//
//  UIBarButtonItem+Extensions.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 14/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import Combine

protocol TargetActionConfigurable: AnyObject {
    var action: Selector? { get set }
    var target: AnyObject? { get set }
}

extension UIBarButtonItem: TargetActionConfigurable { }


extension TargetActionConfigurable {
    var publisher: AnyPublisher<Void, Never> {
        Publishers.TargetActionPublisher(control: self).eraseToAnyPublisher()
    }
}
