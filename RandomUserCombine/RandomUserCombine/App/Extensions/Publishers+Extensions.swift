//
//  Publishers+Extensions.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 14/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import Combine

extension Combine.Publishers {

    struct UIControlPublisher<Control: UIControl>: Publisher {
        typealias Output = Void
        typealias Failure = Never
        
        private let control: Control
        private let controlEvents: UIControl.Event
        
        init(control: Control, events: UIControl.Event) {
            self.control = control
            self.controlEvents = events
        }
        
        func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber, control: control, event: controlEvents)
            subscriber.receive(subscription: subscription)
        }
    }
    
    struct TargetActionPublisher<Control: TargetActionConfigurable>: Publisher {
        typealias Output = Void
        typealias Failure = Never
        
        private let control: Control
        
        init(control: Control) {
            self.control = control
        }
        
        func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber, control: control)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension Combine.Publishers.UIControlPublisher {
    
    private final class Subscription<S: Subscriber, C: UIControl>: Combine.Subscription where S.Input == Void {
        private var subscriber: S?
        weak private var control: C?

        init(subscriber: S, control: C, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive()
        }
    }
}

extension Combine.Publishers.TargetActionPublisher {
    
    private final class Subscription<S: Subscriber, C: TargetActionConfigurable>: Combine.Subscription where S.Input == Void {
        private var subscriber: S?
        weak private var control: C?
        
        private let action = #selector(actionHandler)
        
        init(subscriber: S, control: C) {
            self.subscriber = subscriber
            self.control = control
            control.target = self
            control.action = action
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            subscriber = nil
            control?.target = nil
            control?.action = nil
        }
        
        @objc private func actionHandler() {
            _ = subscriber?.receive()
        }
    }
}
