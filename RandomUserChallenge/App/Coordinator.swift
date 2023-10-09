//
//  Coordinator.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import RxSwift
import Foundation

class Coordinator<T> {
    
    let disposeBag = DisposeBag()
    
    private let identifier = UUID()
    private var coordinators = [UUID: Any]()
    
    func start() -> Observable<T> {
        fatalError("Start method should be implemented")
    }

    func run<U>(_ coordinator: Coordinator<U>) -> Observable<U> {
        add(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.remove(coordinator: coordinator)
            })
    }

    // MARK: - Private methods
    
    private func add<U>(coordinator: Coordinator<U>) {
        coordinators[coordinator.identifier] = coordinator
    }
    
    private func remove<U>(coordinator: Coordinator<U>) {
        coordinators[coordinator.identifier] = nil
    }
}
