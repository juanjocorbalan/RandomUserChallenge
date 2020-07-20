//
//  RandomUserRepository.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

class RandomUserRepository: RandomUserRepositoryType {

    private let apiDataSource: RandomUserAPIDataSourceType
    private let cacheDataSource: RandomUserCacheDataSourceType
    private var cancellables = Set<AnyCancellable>()
    
    init(apiDataSource: RandomUserAPIDataSourceType, cacheDataSource: RandomUserCacheDataSourceType) {
        self.apiDataSource = apiDataSource
        self.cacheDataSource = cacheDataSource
    }
    
    func getUsers() -> AnyPublisher<[RandomUser], Error> {
        
        return apiDataSource.getUsers()
            .flatMap { [weak self] users -> AnyPublisher<[RandomUser], Error> in
                guard let strongSelf = self else { return Just(users).setFailureType(to: Error.self).eraseToAnyPublisher() }
                users.forEach {
                    strongSelf.cacheDataSource
                        .createOrUpdate(user: $0)
                        .subscribe(on: DispatchQueue.global())
                        .sink(receiveCompletion: { _ in }) { _ in }
                        .store(in: &strongSelf.cancellables)
                }
                return Just(users).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .flatMap { [weak self] users -> AnyPublisher<[RandomUser], Error> in
                guard let strongSelf = self else { return Just(users).setFailureType(to: Error.self).eraseToAnyPublisher() }
                return strongSelf.cacheDataSource.get(where: RandomUserCache.keys.isRemoved, equals: false)
        }.eraseToAnyPublisher()
    }

    func deleteUserBy(id: String) -> AnyPublisher<Void, Error> {
        return cacheDataSource.update(by: id, with: [RandomUserCache.keys.isRemoved : true])
    }
}
