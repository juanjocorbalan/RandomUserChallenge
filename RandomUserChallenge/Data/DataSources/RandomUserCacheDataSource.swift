//
//  RandomUserCacheDataSource.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

protocol RandomCacheDataSourceType {
    func getAll() -> Observable<[RandomUser]>
    func get(by id: String) -> Observable<RandomUser>
    func delete(by id: String) -> Observable<Void>
}

class RandomUserCacheDataSource<CacheClient>: RandomCacheDataSourceType where CacheClient: CacheClientType, CacheClient.T == RandomUser {
    
    private let cacheClient: CacheClient
    
    private let bag = DisposeBag()
    
    init(cacheClient: CacheClient) {
        self.cacheClient = cacheClient
    }
    
    func getAll() -> Observable<[RandomUser]> {
        return cacheClient.getAll()
    }
    
    func get(by id: String) -> Observable<RandomUser> {
        return cacheClient.get(key: RandomUserCache.keys.identifier, value: id)
            .flatMap { users -> Observable<RandomUser> in
                guard let user = users.first else  {
                    return Observable.error(CacheError.notFound)
                }
                return Observable.just(user)
            }
    }

    func delete(by id: String) -> Observable<Void> {
        return cacheClient.delete(key: RandomUserCache.keys.identifier, value: id)
    }
}
