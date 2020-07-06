//
//  DeleteUserUseCase.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

class DeleteUserUseCase {
    private let repository: RandomUserRepositoryType
    
    init(repository: RandomUserRepositoryType) {
        self.repository = repository
    }
    
    func execute(with user: RandomUser) -> Observable<Void> {
        return repository.deleteUser(with: user.identifier)
    }
}
