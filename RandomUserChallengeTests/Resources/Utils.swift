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

class MockDependencyContainer: DependencyContainer {
    
    lazy var objectMoel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "RandomUserChallenge", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    var mockApiClient = MockAPIClient()
    
    func reset() {
        mockApiClient.failWithError = false
    }
    
    override func resolve() -> APIClient {
        return mockApiClient
    }
    
    override func resolve() -> CoreDataStack {
        return CoreDataStack(objectModel: mockDependencyContainer.objectMoel, inMemory: true)
    }
}

class MockAPIClient: APIClient {
    
    var failWithError = false
    
    override func execute<R>(_ resource: R) -> Observable<R.ResponseType> where R: ResourceType {
        
        guard !failWithError else { return Observable<R.ResponseType>.error(APIError.serialization) }
        
        var stubResponseFileName = ""
        switch R.ResponseType.self {
        case is [RandomUserDTO].Type:
            stubResponseFileName = "randomUsers"
        default:
            return Observable<R.ResponseType>.error(APIError.serialization)
        }
        guard let results: R.ResponseType = decodeJSONFile(named: stubResponseFileName)
            else { return Observable<R.ResponseType>.error(APIError.serialization) }
        return Observable.just(results)
    }
}

let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)

let mockDependencyContainer = MockDependencyContainer()

let randomUser1 = RandomUser(id: "1", firstName: "name", lastName: "last", email: "email", gender: "gender", ipAddress: "ip", avatar: "", city: "", background: "", description: "")

let randomUser2 = RandomUser(id: "2", firstName: "name", lastName: "last", email: "email", gender: "gender", ipAddress: "ip", avatar: "", city: "", background: "", description: "")
