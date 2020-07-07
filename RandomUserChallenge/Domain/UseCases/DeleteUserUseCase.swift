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
    
    func execute(with user: RandomUser, on users: [RandomUser]) -> Observable<[RandomUser]> {
        var users = users
        return repository.deleteUser(user)
            .flatMap { _ -> Observable<[RandomUser]> in
                if let index = users.firstIndex(where: { $0.id == user.id}) {
                    users.remove(at: index)
                }
                return Observable.of(users)
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)

    }
}
