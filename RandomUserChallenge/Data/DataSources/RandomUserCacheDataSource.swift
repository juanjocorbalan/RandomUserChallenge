//
//  RandomUserCacheDataSource.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

protocol RandomUserCacheDataSourceType {
    func get<V>(where key: String, equals value: V) -> Observable<[RandomUser]>
    func createOrUpdate(user: RandomUser) -> Observable<Void>
    func delete(by id: String) -> Observable<Void>
}

class RandomUserCacheDataSource<CacheClient>: RandomUserCacheDataSourceType where CacheClient: CacheClientType, CacheClient.T == RandomUser {
    
    private let cacheClient: CacheClient
    
    private let bag = DisposeBag()
    
    init(cacheClient: CacheClient) {
        self.cacheClient = cacheClient
    }
    
    func get<V>(where key: String, equals value: V) -> Observable<[RandomUser]> {
        return cacheClient.get(key: key, value: value)
    }

    func createOrUpdate(user: RandomUser) -> Observable<Void> {
        return cacheClient.createOrUpdate(element: user)
    }

    func delete(by id: String) -> Observable<Void> {
        return cacheClient.delete(key: RandomUserCache.keys.id, value: id)
    }
}
