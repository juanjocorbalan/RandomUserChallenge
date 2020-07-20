//
//  Coordinator.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Combine
import Foundation

class Coordinator<T> {
    
    private let identifier = UUID()
    private var coordinators = [UUID: Any]()
    
    func start() -> AnyPublisher<T, Never> {
        fatalError("Start method should be implemented")
    }

    func run<T>(_ coordinator: Coordinator<T>) -> AnyPublisher<T, Never> {
        add(coordinator: coordinator)
        return coordinator.start()
            .handleEvents(receiveOutput: { _ in
                self.remove(coordinator: coordinator)
            }).eraseToAnyPublisher()
    }

    // MARK: - Private methods
    
    private func add<T>(coordinator: Coordinator<T>) {
        coordinators[coordinator.identifier] = coordinator
    }
    
    private func remove<T>(coordinator: Coordinator<T>) {
        
        coordinators[coordinator.identifier] = nil
        
    }
}
