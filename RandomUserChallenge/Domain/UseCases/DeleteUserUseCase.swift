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
    
    func execute(with indexPath: IndexPath, on: [RandomUser]) -> Observable<[RandomUser]> {
        var users = on
        return repository.deleteUser(with: users[indexPath.row].id)
            .flatMap { _ -> Observable<[RandomUser]> in
                users.remove(at: indexPath.row)
                return Observable.of(users)
            }
    }
}
