//
//  RandomUserCacheDataSource.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

protocol RandomUserCacheDataSourceType {
    func get<V>(where key: String, equals value: V) -> AnyPublisher<[RandomUser], Error>
    func createOrUpdate(user: RandomUser) -> AnyPublisher<Void, Error>
    func update(by id: String, with values: [String : Any]) -> AnyPublisher<Void, Error>
    func delete(by id: String) -> AnyPublisher<Void, Error>
}

class RandomUserCacheDataSource<CacheClient>: RandomUserCacheDataSourceType where CacheClient: CacheClientType, CacheClient.T == RandomUser {
    
    private let cacheClient: CacheClient
    
    init(cacheClient: CacheClient) {
        self.cacheClient = cacheClient
    }
    
    func get<V>(where key: String, equals value: V) -> AnyPublisher<[RandomUser], Error> {
        return cacheClient.get(key: key, value: value)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func createOrUpdate(user: RandomUser) -> AnyPublisher<Void, Error> {
        return cacheClient.createOrUpdate(element: user)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func update(by id: String, with values: [String : Any]) -> AnyPublisher<Void, Error> {
        return cacheClient.update(key: RandomUserCache.keys.id, value: id, with: values)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func delete(by id: String) -> AnyPublisher<Void, Error> {
        return cacheClient.delete(key: RandomUserCache.keys.id, value: id)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
