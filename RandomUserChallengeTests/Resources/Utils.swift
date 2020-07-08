//
//  Utils.swift
//  RandomUserChallengeTests
//
//  Created by Juanjo Corbalán on 08/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift
import CoreData
@testable import RandomUserChallenge

class MockCoreDataClient: CoreDataClient<RandomUser> {
    
    init() {
        let bundle = Bundle.init(for: MockCoreDataClient.self)
        let modelURL = bundle.url(forResource: "TestModel", withExtension: "momd")!

        super.init(coreDataStack: CoreDataStack(model: "TestModel", url: modelURL, inMemory: true))
    }
}

class MockAPIClient: APIClient {
    
    override func execute<R>(_ resource: R) -> Observable<R.ResponseType> where R : ResourceType {
        guard let results: [RandomUserDTO] = decodeJSONFile(named: "randomUsers")
            else { return Observable<R.ResponseType>.error(APIError.serialization) }
        return Observable.just(results as! R.ResponseType)
    }
}

class MockRandomUserAPIDataSource: RandomUserAPIDataSource {
    
    init() {
        super.init(apiClient: MockAPIClient())
    }
}

class MockRandomUserCacheDataSource: RandomUserCacheDataSource<MockCoreDataClient> {

    init() {
        super.init(cacheClient: MockCoreDataClient())
    }
}

class MockRandomUserRepository: RandomUserRepository {
    
    init() {
        super.init(apiDataSource: MockRandomUserAPIDataSource(),
                   cacheDataSource: MockRandomUserCacheDataSource())
    }
}

class MockGetRandomUsersUseCase: GetUsersUseCase {
    
    init() {
        super.init(repository: MockRandomUserRepository())
    }
}

let mockCoreDataClient = MockCoreDataClient()

let randomUser1 = RandomUser(id: "1", firstName: "name", lastName: "last", email: "email", gender: "gender", ipAddress: "ip", avatar: "", city: "", background: "", description: "")
let randomUser2 = RandomUser(id: "2", firstName: "name", lastName: "last", email: "email", gender: "gender", ipAddress: "ip", avatar: "", city: "", background: "", description: "")
