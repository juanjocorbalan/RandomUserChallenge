//
//  GetUsersUseCase.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

class GetUsersUseCase {
    private let repository: RandomUserRepositoryType
    
    init(repository: RandomUserRepositoryType) {
        self.repository = repository
    }
    
    func execute() -> Observable<[RandomUser]> {
        return repository.getUsers().debug()
    }
}
