//
//  RandomUserRepository.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

class RandomUserRepository: RandomUserRepositoryType {

    private let apiDataSource: RandomUserAPIDataSourceType
    private let cacheDataSource: RandomUserCacheDataSourceType
    private let disposeBag = DisposeBag()
    
    init(apiDataSource: RandomUserAPIDataSourceType, cacheDataSource: RandomUserCacheDataSourceType) {
        self.apiDataSource = apiDataSource
        self.cacheDataSource = cacheDataSource
    }
    
    func getUsers() -> Observable<[RandomUser]> {
        
        return apiDataSource.getUsers()
            .flatMap { [weak self] users -> Observable<[RandomUser]> in
                guard let strongSelf = self else { return Observable.just(users) }
                users.forEach {
                    strongSelf.cacheDataSource
                        .createOrUpdate(user: $0)
                        .subscribe()
                        .disposed(by: strongSelf.disposeBag)
                }
                return Observable.just(users)
            }
            .flatMap { [weak self] users -> Observable<[RandomUser]> in
                guard let strongSelf = self else { return Observable.just(users) }
                return strongSelf.cacheDataSource.get(where: RandomUserCache.keys.isRemoved, equals: false)
            }
    }

    func deleteUserBy(id: String) -> Observable<Void> {
        return cacheDataSource.update(by: id, with: [RandomUserCache.keys.isRemoved : true])
    }
}
