//
//  GetUsersUseCase.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

class GetUsersUseCase {
    private let repository: RandomUserRepositoryType
    
    init(repository: RandomUserRepositoryType) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[RandomUser], Error> {
        return repository.getUsers()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
